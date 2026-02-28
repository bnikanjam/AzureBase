# ---------------------------------------------------------------------------
# Remote state data sources
# ---------------------------------------------------------------------------

data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l0-bootstrap"
    key                  = "terraform.tfstate"
  }
}

data "terraform_remote_state" "connectivity" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l2-connectivity"
    key                  = "terraform.tfstate"
  }
}

# ---------------------------------------------------------------------------
# Naming modules
# ---------------------------------------------------------------------------

module "naming_rg" {
  source        = "../../modules/naming"
  app           = "shared"
  env           = "prdx"
  region        = var.location
  resource_type = "rg"
  instance      = "001"
}

module "naming_cr" {
  source        = "../../modules/naming"
  app           = "shared"
  env           = "prdx"
  region        = var.location
  resource_type = "cr"
  instance      = "001"
}

# ---------------------------------------------------------------------------
# Resource group
# ---------------------------------------------------------------------------

resource "azurerm_resource_group" "shared" {
  name     = module.naming_rg.name
  location = var.location
  tags     = var.tags
}

# ---------------------------------------------------------------------------
# Spoke Virtual Network
# ---------------------------------------------------------------------------

module "spoke_network" {
  source = "../../modules/spoke-network"

  spoke_name          = "shared"
  env                 = "prdx"
  location            = var.location
  resource_group_name = azurerm_resource_group.shared.name

  spoke_vnet_address_space = ["10.1.0.0/24"]

  subnets = {
    "snet-pe" = {
      address_prefixes = ["10.1.0.0/26"]
    }
  }

  hub_vnet_id             = data.terraform_remote_state.connectivity.outputs.hub_vnet_id
  hub_vnet_name           = data.terraform_remote_state.connectivity.outputs.hub_vnet_name
  hub_resource_group_name = data.terraform_remote_state.connectivity.outputs.hub_resource_group_name
  firewall_private_ip     = data.terraform_remote_state.connectivity.outputs.firewall_private_ip

  private_dns_zone_ids         = data.terraform_remote_state.connectivity.outputs.private_dns_zone_ids
  dns_zone_resource_group_name = data.terraform_remote_state.connectivity.outputs.hub_resource_group_name

  tags = var.tags
}

# ---------------------------------------------------------------------------
# Azure Container Registry
# ---------------------------------------------------------------------------

resource "azurerm_container_registry" "shared" {
  name                          = replace(module.naming_cr.name, "-", "")
  location                      = azurerm_resource_group.shared.location
  resource_group_name           = azurerm_resource_group.shared.name
  sku                           = var.acr_sku
  public_network_access_enabled = false
  tags                          = var.tags
}

# ---------------------------------------------------------------------------
# Private endpoint for ACR
# ---------------------------------------------------------------------------

module "acr_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                           = "${replace(module.naming_cr.name, "-", "")}-pe"
  location                       = azurerm_resource_group.shared.location
  resource_group_name            = azurerm_resource_group.shared.name
  subnet_id                      = module.spoke_network.subnet_ids["snet-pe"]
  private_connection_resource_id = azurerm_container_registry.shared.id
  subresource_names              = ["registry"]
  private_dns_zone_ids           = [data.terraform_remote_state.connectivity.outputs.private_dns_zone_ids["privatelink.azurecr.io"]]
  tags                           = var.tags
}
