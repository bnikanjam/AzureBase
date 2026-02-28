# ---------------------------------------------------------------------------
# Remote state – read L0-bootstrap outputs
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# ALZ Platform Landing Zone pattern module
# ---------------------------------------------------------------------------

module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.19.0"

  location          = var.location
  architecture_name = var.architecture_name

  management_group_hierarchy_settings = {
    root_management_group_display_name = var.tenant_root_management_group_display_name
  }

  subscription_placement = {
    management = {
      subscription_id       = var.management_subscription_id
      management_group_name = "management"
    }
    connectivity = {
      subscription_id       = var.connectivity_subscription_id
      management_group_name = "connectivity"
    }
    identity = {
      subscription_id       = var.identity_subscription_id
      management_group_name = "identity"
    }
  }
}
