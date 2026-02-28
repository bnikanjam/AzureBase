# Azure Landing Zone Foundation

Terraform IaC for Azure governance, networking, and platform resources following the Azure Landing Zone architecture.

## Quick Start

1. Install prerequisites: Terraform >= 1.9, Azure CLI, GitHub CLI
2. Authenticate: `az login`
3. Bootstrap: `cd layers/L0-bootstrap && terraform init && terraform apply`
4. Deploy layers in order via CI/CD after bootstrap

## Structure

```
layers/          # Deployment layers (L0-L4)
modules/         # Reusable Terraform modules
tests/           # Module tests
.github/         # CI/CD workflows
```

See [CLAUDE.md](CLAUDE.md) for architecture details and conventions.
