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

data "terraform_remote_state" "management" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l1-management"
    key                  = "terraform.tfstate"
  }
}

data "terraform_remote_state" "shared" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l3-shared"
    key                  = "terraform.tfstate"
  }
}

data "terraform_remote_state" "cloudflare" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l2-cloudflare"
    key                  = "terraform.tfstate"
  }
}

# ---------------------------------------------------------------------------
# Naming modules
# ---------------------------------------------------------------------------

module "naming_rg" {
  source        = "../../modules/naming"
  app           = var.app_name
  env           = var.env
  region        = var.location
  resource_type = "rg"
  instance      = "001"
}

module "naming_cae" {
  source        = "../../modules/naming"
  app           = var.app_name
  env           = var.env
  region        = var.location
  resource_type = "cae"
  instance      = "001"
}

module "naming_ca" {
  source        = "../../modules/naming"
  app           = var.app_name
  env           = var.env
  region        = var.location
  resource_type = "ca"
  instance      = "001"
}

module "naming_kv" {
  source        = "../../modules/naming"
  app           = var.app_name
  env           = var.env
  region        = var.location
  resource_type = "kv"
  instance      = "001"
}

module "naming_id" {
  source        = "../../modules/naming"
  app           = var.app_name
  env           = var.env
  region        = var.location
  resource_type = "id"
  instance      = "001"
}

# ---------------------------------------------------------------------------
# Resource group
# ---------------------------------------------------------------------------

resource "azurerm_resource_group" "app" {
  name     = module.naming_rg.name
  location = var.location
  tags     = var.tags
}

# ---------------------------------------------------------------------------
# User-assigned managed identity
# ---------------------------------------------------------------------------

resource "azurerm_user_assigned_identity" "app" {
  name                = module.naming_id.name
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  tags                = var.tags
}

# ---------------------------------------------------------------------------
# Spoke Virtual Network
# ---------------------------------------------------------------------------

module "spoke" {
  source = "../../modules/spoke-network"

  spoke_name          = var.app_name
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name

  spoke_vnet_address_space = var.spoke_address_space

  subnets = {
    "snet-pe" = {
      address_prefixes = [var.pe_subnet_prefix]
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
# ACA subnet (separate — requires delegation for Microsoft.App/environments)
# ---------------------------------------------------------------------------

resource "azurerm_subnet" "aca" {
  name                 = "snet-aca"
  resource_group_name  = azurerm_resource_group.app.name
  virtual_network_name = module.spoke.spoke_vnet_name
  address_prefixes     = [var.aca_subnet_prefix]

  delegation {
    name = "Microsoft.App.environments"

    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# ---------------------------------------------------------------------------
# Container App Environment
# ---------------------------------------------------------------------------

module "container_app_env" {
  source = "../../modules/container-app-env"

  name                       = module.naming_cae.name
  location                   = azurerm_resource_group.app.location
  resource_group_name        = azurerm_resource_group.app.name
  subnet_id                  = azurerm_subnet.aca.id
  log_analytics_workspace_id = data.terraform_remote_state.management.outputs.log_analytics_workspace_id
  tags                       = var.tags
}

# ---------------------------------------------------------------------------
# Container App
# ---------------------------------------------------------------------------

module "container_app" {
  source = "../../modules/container-app"

  name                         = module.naming_ca.name
  resource_group_name          = azurerm_resource_group.app.name
  container_app_environment_id = module.container_app_env.id
  registry_server              = data.terraform_remote_state.shared.outputs.acr_login_server
  image                        = var.container_image
  cpu                          = var.container_cpu
  memory                       = var.container_memory
  min_replicas                 = var.min_replicas
  max_replicas                 = var.max_replicas
  target_port                  = var.target_port
  identity_ids                 = [azurerm_user_assigned_identity.app.id]
  tags                         = var.tags
}

# ---------------------------------------------------------------------------
# Key Vault
# ---------------------------------------------------------------------------

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                          = module.naming_kv.name
  location                      = azurerm_resource_group.app.location
  resource_group_name           = azurerm_resource_group.app.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 30
  purge_protection_enabled      = true
  public_network_access_enabled = false
  enable_rbac_authorization     = true
  tags                          = var.tags
}

module "kv_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                           = "${module.naming_kv.name}-pe"
  location                       = azurerm_resource_group.app.location
  resource_group_name            = azurerm_resource_group.app.name
  subnet_id                      = module.spoke.subnet_ids["snet-pe"]
  private_connection_resource_id = azurerm_key_vault.this.id
  subresource_names              = ["vault"]
  private_dns_zone_ids           = [data.terraform_remote_state.connectivity.outputs.private_dns_zone_ids["privatelink.vaultcore.azure.net"]]
  tags                           = var.tags
}

# ---------------------------------------------------------------------------
# Role assignments
# ---------------------------------------------------------------------------

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.terraform_remote_state.shared.outputs.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

# ---------------------------------------------------------------------------
# Firewall DNAT rule (created in hub subscription)
# ---------------------------------------------------------------------------

resource "azurerm_firewall_nat_rule_collection" "app_dnat" {
  provider            = azurerm.hub
  name                = "${var.app_name}-${var.env}-dnat"
  azure_firewall_name = data.terraform_remote_state.connectivity.outputs.firewall_name
  resource_group_name = data.terraform_remote_state.connectivity.outputs.firewall_resource_group_name
  priority            = 200
  action              = "Dnat"

  rule {
    name                  = "${var.app_name}-${var.env}-https"
    source_addresses      = ["*"]
    destination_ports     = ["443"]
    destination_addresses = [data.terraform_remote_state.connectivity.outputs.firewall_public_ip]
    translated_address    = module.container_app_env.static_ip_address
    translated_port       = tostring(var.target_port)
    protocols             = ["TCP"]
  }
}

# ---------------------------------------------------------------------------
# Cloudflare DNS entry
# ---------------------------------------------------------------------------

module "cloudflare_dns" {
  source = "../../modules/cloudflare-app-entry"

  zone_id       = data.terraform_remote_state.cloudflare.outputs.zone_id
  app_subdomain = var.app_subdomain
  origin_ip     = data.terraform_remote_state.connectivity.outputs.firewall_public_ip
  proxied       = true
}
