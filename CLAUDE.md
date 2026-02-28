# Azure Landing Zone Foundation

## Project Overview

Terraform IaC for Azure governance, networking, and platform resources. Uses a layered architecture (L0-L4) with isolated state per layer and OIDC authentication for CI/CD.

## Architecture

- **Container platform:** Azure Container Apps
- **CI/CD:** GitHub Actions with OIDC
- **DNS/WAF:** Cloudflare (domain registration, DNS proxying, WAF)
- **Networking:** Hub-spoke with Azure Firewall
- **State:** Single storage account, one blob container per layer

## Naming Convention

Format: `{app}-{env}-{region4}-{resource-abb}-{instance}`

- **app:** lowercase short name (hub, myapp, platform)
- **env:** 4-char code (prdx, stgx, devx, cicd)
- **region:** 2-char country + 2-char id (use1, usw2, euw1)
- **resource:** CAF abbreviation (vnet, afw, rg, kv, ca, cae, st, nsg)
- **instance:** 3-digit (001, 002)

Storage accounts and key vaults strip hyphens and truncate to 24 chars.

## Layer Dependencies

```
L0-bootstrap (state storage + OIDC)
├── L1-governance (mgmt groups + policies)
├── L1-management (logging + monitoring)
│   └── L2-connectivity (hub networking + firewall)
│       └── L2-cloudflare (DNS + WAF)
```

## Provider Versions

- Terraform: 1.14.6
- azurerm: 4.62.0
- azapi: 2.8.0
- azuread: 3.8.0
- cloudflare: 5.17.0
- alz: 0.20.2

## Commands

- `terraform fmt -recursive` — format all files
- `terraform validate` — validate a layer (run from layer directory)
- `terraform test` — run naming module tests (from repo root)
- `terraform plan` — plan changes (run from layer directory)

## Development Rules

- Always use the naming module for resource names
- Cross-layer references use `terraform_remote_state` data sources
- Each layer has its own OIDC identity with least-privilege scope
- Never hardcode regions — parameterize per workload
- Feature branch workflow: branch -> PR -> merge to main
