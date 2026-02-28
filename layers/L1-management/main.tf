data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l0-bootstrap"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

# --- Naming ---

module "naming_rg" {
  source        = "../../modules/naming"
  app           = "platform"
  env           = "prdx"
  region        = var.location
  resource_type = "rg"
  instance      = "001"
}

module "naming_log" {
  source        = "../../modules/naming"
  app           = "platform"
  env           = "prdx"
  region        = var.location
  resource_type = "log"
  instance      = "001"
}

module "naming_aa" {
  source        = "../../modules/naming"
  app           = "platform"
  env           = "prdx"
  region        = var.location
  resource_type = "aa"
  instance      = "001"
}

# --- Resource Group ---

resource "azurerm_resource_group" "management" {
  name     = module.naming_rg.name
  location = var.location
}

# --- ALZ Management Module ---

module "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "~> 0.4"

  automation_account_name      = module.naming_aa.name
  location                     = azurerm_resource_group.management.location
  resource_group_name          = azurerm_resource_group.management.name
  log_analytics_workspace_name = module.naming_log.name

  resource_group_creation_enabled = false

  log_analytics_workspace_retention_in_days = var.log_analytics_retention_days
}
