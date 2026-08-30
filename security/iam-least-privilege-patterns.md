# 📌 IAM Least-Privilege Patterns: ABAC vs RBAC

> **Difficulty:** 🔴 Specialty
> **Domain:** Security > IAM
> **Keywords:** `iam`, `abac`, `rbac`, `least-privilege`, `tags`, `permission-boundaries`

---

## 🔍 Problem Statement

Your platform has hundreds of engineers across dozens of teams and environments. With
pure role-based access control (RBAC) you end up creating a new IAM role/policy for
every team × environment × resource combination — a policy explosion that's hard to
audit and drifts from least privilege. The question: **How do you grant least-
privilege access at scale, and when do you choose Attribute-Based Access Control
(ABAC) over Role-Based Access Control (RBAC)?**

## 🚀 Solution & Architecture Decision

- **RBAC** grants permissions by *role*: you define a policy per role that names the
  resources it can touch (often by ARN or ARN prefix). Simple and explicit, but the
  number of policies grows with every new team/environment/resource dimension.
- **ABAC** grants permissions by *matching tags*: the policy says "a principal may act
  on a resource **only when** the principal's tag equals the resource's tag" (e.g.
  `aws:PrincipalTag/team == aws:ResourceTag/team`). One policy scales across many
  teams because access is decided by attributes, not enumerated ARNs.

The mature answer is usually **ABAC layered on top of a small RBAC baseline**:

1. Use a **few broad roles** (e.g. `Developer`, `ReadOnly`, `Admin`) — the RBAC
   baseline for *what actions* are allowed.
2. Use **ABAC tag conditions** to scope *which resources* each principal can act on,
   so one `Developer` policy serves every team without per-team policies.
3. Enforce **Permission Boundaries** and **SCPs** so delegated admins can't escalate
   privileges or remove the guardrails — including a rule that principals can't tamper
   with the tags that drive access decisions.

### Decision Drivers

- **Scale & churn of teams/projects** → ABAC (add a team by tagging, not by writing a
  new policy).
- **Strict, enumerable, rarely-changing resource sets** → RBAC is simpler and easier
  to reason about.
- **Tag governance maturity** → ABAC *requires* trustworthy, enforced tags; without
  tag governance, ABAC is a security risk.
- **Auditability** → RBAC policies are explicit; ABAC needs you to audit tags and tag-
  setting permissions.

### Architecture Diagram (Optional)

```text
   Principal (SSO session)                 Resource
   tag: team=payments        ┌────────┐    tag: team=payments
   tag: env=prod             │  IAM   │    tag: env=prod
        │                    │ policy │         │
        └── aws:PrincipalTag ─▶ evaluates ◀─ aws:ResourceTag ──┘
                             │  Allow IF    │
                             │  team == team│
                             │  AND env==env│
                             └──────┬───────┘
              Permission Boundary + SCP cap the maximum, prevent tag tampering
```

## 🛠️ Code / Configuration

An **ABAC policy**: allow EC2 start/stop only when the caller's `team`/`env` tags
match the instance's, and forbid changing the governing tags:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ManageOwnTeamEnvInstances",
      "Effect": "Allow",
      "Action": ["ec2:StartInstances", "ec2:StopInstances", "ec2:RebootInstances"],
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/team": "${aws:PrincipalTag/team}",
          "aws:ResourceTag/env": "${aws:PrincipalTag/env}"
        }
      }
    },
    {
      "Sid": "RequireTagsOnRunInstances",
      "Effect": "Allow",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringEquals": {
          "aws:RequestTag/team": "${aws:PrincipalTag/team}",
          "aws:RequestTag/env": "${aws:PrincipalTag/env}"
        }
      }
    },
    {
      "Sid": "DenyTagTampering",
      "Effect": "Deny",
      "Action": ["ec2:CreateTags", "ec2:DeleteTags"],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringEquals": {
          "aws:TagKeys": ["team", "env"]
        }
      }
    }
  ]
}
```

A **Permission Boundary** attached to every delegated role so it can never exceed the
intended ceiling (Terraform):

```hcl
resource "aws_iam_role" "developer" {
  name                 = "developer"
  permissions_boundary = aws_iam_policy.boundary.arn
  assume_role_policy   = data.aws_iam_policy_document.sso_trust.json
}

resource "aws_iam_policy" "boundary" {
  name   = "developer-boundary"
  policy = data.aws_iam_policy_document.boundary.json
}
```

## ⚖️ Trade-offs & Alternatives Considered

| Option | Pros | Cons | Cost Impact |
| -------- | ------ | ------ | ------------- |
| **ABAC (+ RBAC baseline)** (chosen) | Scales to many teams with few policies; new teams onboard via tags; permissions self-describe via tags | Requires enforced tag governance; harder to audit "who can do what"; tag mistakes = access mistakes | $0 (IAM is free) |
| **Pure RBAC** | Explicit and easy to audit; no tag dependency | Policy explosion (team × env × resource); slow onboarding; drifts from least privilege | $0 |
| **Broad shared admin roles** | Fast to set up | Violates least privilege; large blast radius; fails audits | $0 (but high risk cost) |

**Guardrails apply to all options:** use **SCPs** (Organizations) to set hard
boundaries the account can never cross, **Permission Boundaries** to cap delegated
roles, and **IAM Access Analyzer** to detect unintended external access and unused
permissions.

## 💰 Cost Estimation

IAM itself has **no direct charge** — roles, policies, ABAC conditions, and permission
boundaries are free. Relevant costs are adjacent and optional:

- **AWS IAM Identity Center (SSO):** no additional charge.
- **IAM Access Analyzer:** external-access analysis is free; **unused-access
  analysis** is charged per analyzed IAM role/user per month (~$0.20 range) — budget
  a few dollars/month for a mid-size org.
- **Indirect savings:** the real "cost" avoided is operational — fewer policies to
  maintain and a smaller breach blast radius. That's the ROI of getting least
  privilege right.

## 📚 References

- [What is ABAC for AWS?](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html)
- [IAM tutorial: Define permissions using attributes (ABAC)](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_attribute-based-access-control.html)
- [Permissions boundaries for IAM entities](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html)
- [Using AWS IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)
