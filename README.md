# HelloCloud Infrastructure - Multi-Module Terraform Project

This repository contains a refactored multi-folder Terraform project split into separate root modules for frontend and backend tiers. Cross-module and cross-VPC dependencies (including VPC Peering) are managed using remote state data sources.

---

## 📚 Lessons (one branch each)

Each lesson is a branch with its own write-up in `docs/`, real HCP/AWS logs and screenshots, and a matching Excalidraw drawing.

| Branch | Lesson |
|---|---|
| `main` | The lecture code as handed out (starting point) |
| `01-hcp-migration-troubleshooting` | Move the frontend stack to a new HCP org and fix every error on the way ([docs](docs/01-hcp-migration/README.md)) |
| `02-local-file-drift` | Why `local_file` can't hand you an SSH key under remote execution ([docs](docs/02-local-file-drift/README.md)) |
| `03-option-b-sensitive-output` | Fix B: retrieve the key through a sensitive output |
| `04-option-a-secrets-manager` | Fix A: pre-created key in Secrets Manager, read ephemerally |
| `05-option-c-ssm-no-keys` | Fix C: no SSH keys at all, use SSM Session Manager |
| `06-enterprise-practices` | Production hardening: OIDC credentials, secrets out of state, no provisioners |

```bash
git switch 01-hcp-migration-troubleshooting     # start here
git diff main 01-hcp-migration-troubleshooting   # see exactly what the lesson changed
```

---

## 🏗️ Project Architecture & Deployment Order

Because modules depend on each other's outputs (e.g., VPC peering requires backend network outputs, security groups need VPC IDs, and compute instances need subnets and security groups), you **must apply and destroy them in a strict sequence**.

### Deployment Order (Apply First to Last)
1. **`backend-network`** (Must be applied first so its VPC outputs are available for peering)
2. **`frontend-network`** (Deploys frontend VPC and establishes the VPC peering connection to the backend)
3. **`frontend-security`** & **`backend-security`** (Creates security groups referencing the networks)
4. **`frontend-compute`** & **`backend-compute`** (Deploys EC2 instances, key pairs, EIPs, and provisioners)

---

## 🚀 Standard Terraform Workflow

For **each** folder, navigate into the directory and run the commands in this exact sequence:

```bash
# 1. Initialize the working directory (downloads providers and configures backend)
terraform init

# 2. Format your configuration files to canonical style
terraform fmt

# 3. Validate the configuration syntax and references
terraform validate

# 4. Preview the execution plan
terraform plan

# 5. Apply the changes to build the infrastructure
terraform apply

💰 CRITICAL WARNING: PREVENT UNWANTED AWS CHARGES!
When you are finished testing or your lecture is complete, you MUST run `terraform destroy` on all modules. Leaving EC2 instances, Elastic IPs (EIPs), and NAT Gateways running will incur ongoing hourly charges on your AWS bill.