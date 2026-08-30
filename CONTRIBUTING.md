# Contributing

Thank you for helping build a high-quality AWS interview knowledge base! This guide
explains the format, conventions, and workflow so your contribution merges smoothly.

## Ground rules

- **Accuracy first.** Answers must be technically correct and current. Cite
  [AWS documentation](https://docs.aws.amazon.com/) for any non-obvious limit,
  quota, or behavior.
- **Explain trade-offs.** For scenario and architecture questions, always include a
  **Trade-offs / Pitfalls** section — this is what distinguishes a great answer.
- **No copy-paste from copyrighted sources.** Write in your own words.
- **Be respectful.** See the [Code of Conduct](CODE_OF_CONDUCT.md).

## Where content goes

Pick the domain that best fits your question:

| Domain | Use for |
| -------- | --------- |
| `compute/` | EC2, Lambda, ECS, EKS, Fargate |
| `networking/` | VPC, Transit Gateway, Route 53, CloudFront, Direct Connect |
| `storage/` | S3, EBS, EFS, FSx, Storage Gateway |
| `databases/` | RDS, Aurora, DynamoDB, ElastiCache, Redshift |
| `security/` | IAM, KMS, Secrets Manager, GuardDuty, Security Hub |
| `automation-iac/` | Terraform, CloudFormation, CDK, GitOps |
| `data-analytics/` | Glue, Athena, Kinesis, EMR, Lake Formation |
| `operations-scenarios/` | DR, troubleshooting, cost optimization, SRE, open-ended design |

## File naming

- Service-focused: `<service>-<level>.md` — e.g. `s3-associate.md`, `iam-professional.md`.
- Scenario-focused: a descriptive slug — e.g. `multi-region-dr.md`, `cost-runaway-investigation.md`.
- Use lowercase with hyphens; keep names short and specific.

## Answer format

Every entry follows the `TEMPLATE.md` that lives in each module folder (e.g.
[`compute/TEMPLATE.md`](compute/TEMPLATE.md)). Copy it as your starting point. The
required sections are:

- **Title** with a **Difficulty** badge, **Domain**, and **Keywords**.
- **🔍 Problem Statement** — the scenario or question as asked.
- **🚀 Solution & Architecture Decision** — the walkthrough plus **Decision Drivers**
  (explain the *why*, not just the *what*).
- **🛠️ Code / Configuration** — a real, runnable snippet (Terraform, CloudFormation,
  AWS CLI, or `boto3`).
- **⚖️ Trade-offs & Alternatives Considered** — the comparison table.
- **💰 Cost Estimation** — a realistic monthly range.
- **📚 References** — links to AWS docs / talks.

### Quality bar

Every merged entry **must** include a real code snippet, an explicit trade-offs
table, and a cost impact. Difficulty is one of 🟢 **Associate**, 🟡 **Professional**,
or 🔴 **Specialty**. After adding an entry, add a row to the domain `README.md`
question table.

## Workflow

1. **Fork** the repo and create a branch: `git checkout -b add-s3-lifecycle-question`.
2. **Add or edit** content following the format above.
3. Run **Markdown lint** locally (optional but appreciated):
   `npx markdownlint-cli2 "**/*.md"`.
4. **Open a PR** using the pull request template. Use a
   [Conventional Commits](https://www.conventionalcommits.org/) title, e.g.
   `docs: add S3 lifecycle question` or `fix: correct DynamoDB RCU explanation`.
5. CI runs Markdown lint and a link check — make sure both pass.
6. A maintainer reviews for accuracy and format, then merges. 🎉

## Reporting issues

Not ready to open a PR? Use the issue templates instead:

- **💬 New Interview Question / Scenario** — log a real question and its context.
- **🔧 Correction** — flag an inaccuracy in an existing answer.

Questions and discussion? Open a
[Discussion](https://github.com/anubhav-ojha/cloud-interview-prep/discussions).
