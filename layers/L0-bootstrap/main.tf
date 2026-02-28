# -----------------------------------------------------------------------------
# Naming
# -----------------------------------------------------------------------------

module "naming_rg" {
  source        = "../../modules/naming"
  app           = "platform"
  env           = "cicd"
  region        = var.region
  resource_type = "rg"
  instance      = "001"
}

module "naming_st" {
  source        = "../../modules/naming"
  app           = "platform"
  env           = "cicd"
  region        = var.region
  resource_type = "st"
  instance      = "001"
}

# -----------------------------------------------------------------------------
# Resource Group
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "state" {
  name     = module.naming_rg.name
  location = var.region
}

# -----------------------------------------------------------------------------
# Storage Account for Terraform State
# -----------------------------------------------------------------------------

resource "azurerm_storage_account" "state" {
  name                     = module.naming_st.name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }
}

# -----------------------------------------------------------------------------
# Blob Containers (one per layer)
# -----------------------------------------------------------------------------

resource "azurerm_storage_container" "state" {
  for_each              = toset(var.state_container_names)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

# -----------------------------------------------------------------------------
# Azure AD Application Registrations (OIDC)
# -----------------------------------------------------------------------------

data "azuread_client_config" "current" {}

resource "azuread_application" "oidc" {
  for_each     = var.service_principals
  display_name = each.value

  owners = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "oidc" {
  for_each  = azuread_application.oidc
  client_id = each.value.client_id

  owners = [data.azuread_client_config.current.object_id]
}

# -----------------------------------------------------------------------------
# Federated Identity Credentials for GitHub Actions
# -----------------------------------------------------------------------------

resource "azuread_application_federated_identity_credential" "main_branch" {
  for_each       = azuread_application.oidc
  application_id = each.value.id
  display_name   = "${each.value.display_name}-main"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}

resource "azuread_application_federated_identity_credential" "pull_request" {
  for_each       = azuread_application.oidc
  application_id = each.value.id
  display_name   = "${each.value.display_name}-pr"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.github_repo}:pull_request"
}
