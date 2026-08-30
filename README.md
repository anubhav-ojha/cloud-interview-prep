# ☁️ AWS Cloud Engineer Interview Prep

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-blue.svg)](CONTRIBUTING.md)
[![Markdown Lint](https://github.com/anubhav-ojha/cloud-interview-prep/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/anubhav-ojha/cloud-interview-prep/actions/workflows/markdown-lint.yml)

A community-maintained knowledge base of **AWS Cloud Engineer interview questions, real-world production scenarios, and architecture decisions** — organized by service domain, tagged by difficulty, and written to a consistent bar: every entry explains the *why* behind a decision, the trade-offs against the alternatives, and the cost impact. It is built for engineers preparing for interviews (Associate → Professional → Specialty) and for anyone who wants a fast, opinionated reference before an architecture review.

## 📂 Repository Structure

```text
cloud-interview-prep/
├── compute/               # EC2, Lambda, ECS, EKS, Fargate
├── networking/            # VPC, Transit Gateway, Route 53, CloudFront, Direct Connect
├── storage/               # S3, EBS, EFS, FSx, Storage Gateway
├── databases/             # RDS, Aurora, DynamoDB, ElastiCache, Redshift
├── security/              # IAM, KMS, Secrets Manager, GuardDuty, Security Hub
├── automation-iac/        # Terraform, CloudFormation, CDK, GitOps patterns
├── data-analytics/        # Glue, Athena, Kinesis, EMR, Lake Formation
├── operations-scenarios/  # DR, troubleshooting, cost optimization, SRE
├── .github/
│   ├── ISSUE_TEMPLATE/    # Log new questions & corrections
│   └── workflows/         # CI: Markdown linting
├── CONTRIBUTING.md
└── README.md
```

Each module folder contains a `TEMPLATE.md` (the required structure for every entry) and one Markdown file per question or scenario.

## 🔗 Modules

| Module | Topics Covered |
| -------- | ---------------- |
| [compute](compute/) | EC2 instance families & pricing, Lambda (cold starts, concurrency, SnapStart), ECS/Fargate, EKS |
| [networking](networking/) | VPC design, Transit Gateway, VPC peering, PrivateLink, Route 53, CloudFront, Direct Connect |
| [storage](storage/) | S3 classes & lifecycle, EBS volume types, EFS/FSx, Storage Gateway, durability trade-offs |
| [databases](databases/) | RDS & Aurora, DynamoDB data modeling & capacity, ElastiCache, Redshift |
| [security](security/) | IAM (RBAC vs ABAC, boundaries, SCPs), KMS, Secrets Manager, GuardDuty, Security Hub |
| [automation-iac](automation-iac/) | Terraform state & modules, CloudFormation, CDK, GitOps & policy-as-code |
| [data-analytics](data-analytics/) | Glue, Athena, Kinesis, EMR, Lake Formation, data-lake governance |
| [operations-scenarios](operations-scenarios/) | Disaster recovery, incident troubleshooting, cost optimization, SRE/observability |

## 🎯 How to Use This Repo

**1. Interview preparation.** Browse the module for the service you'll be grilled on, or filter mentally by difficulty. Read the **Solution & Architecture Decision** and **Trade-offs** sections out loud — being able to justify a choice *and* name what you gave up is what separates an Associate answer from a Professional one.

**2. Architecture review.** Reach for a scenario file when you're about to make (or defend) a real decision — e.g. `networking/vpc-multi-account-connectivity.md` before choosing Transit Gateway over VPC peering. Each entry includes decision drivers, a trade-off table, and a rough cost estimate you can adapt.

**3. Contribution.** Hit a great interview question or solved a gnarly production problem? Log it as an issue, then write it up as a PR using the module `TEMPLATE.md`. Sharing the reasoning helps the next engineer — see the guide below.

## 🤝 Contribution Guide

Contributions are the whole point of this repo. The workflow:

1. **Log it first (optional but encouraged).** Open a
   [**💬 New Interview Question / Scenario**](.github/ISSUE_TEMPLATE/new-interview-question.md)
   issue to capture the question and context *before* writing it up. This lets others know it's in progress and avoids duplicates.
2. **Fork** the repository.
3. **Branch** off `main` with a descriptive name, e.g. `git checkout -b compute/lambda-cold-start`.
4. **Write** your entry in the correct module folder, copying that folder's `TEMPLATE.md` as your starting structure.
5. **Open a PR** using a [Conventional Commits](https://www.conventionalcommits.org/) title (e.g. `docs: add Lambda cold start optimization`). CI runs Markdown lint — make sure it passes.

### Quality bar

Every entry **must** include:

- ✅ A **real, runnable code snippet** — Terraform, CloudFormation, AWS CLI, or `boto3` — not pseudocode.
- ✅ An explicit **trade-offs & alternatives** section (use the table in the template).
- ✅ A realistic **cost impact / estimation**, even if it's a rough monthly range.

Answers without the *why*, the trade-offs, and the cost story will be asked to iterate before merge.

## 🎓 Difficulty Levels

| Badge | Level | Scope |
| ------- | ------- | ------- |
| 🟢 | **Associate** | Core service knowledge — Solutions Architect / Developer / SysOps Associate depth. |
| 🟡 | **Professional** | Multi-account, multi-region, trade-off-heavy — Solutions Architect / DevOps Professional depth. |
| 🔴 | **Specialty** | Deep domain expertise — Security, Networking, Data Analytics, Machine Learning specialties. |
