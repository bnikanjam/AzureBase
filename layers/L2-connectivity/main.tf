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

data "terraform_remote_state" "management" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l1-management"
    key                  = "terraform.tfstate"
  }
}

# ---------------------------------------------------------------------------
# Naming modules
# ---------------------------------------------------------------------------

module "naming_rg" {
  source        = "../../modules/naming"
  app           = "hub"
  env           = "prdx"
  region        = var.location
  resource_type = "rg"
  instance      = "001"
}

module "naming_vnet" {
  source        = "../../modules/naming"
  app           = "hub"
  env           = "prdx"
  region        = var.location
  resource_type = "vnet"
  instance      = "001"
}

module "naming_firewall" {
  source        = "../../modules/naming"
  app           = "hub"
  env           = "prdx"
  region        = var.location
  resource_type = "afw"
  instance      = "001"
}

module "naming_bastion" {
  source        = "../../modules/naming"
  app           = "hub"
  env           = "prdx"
  region        = var.location
  resource_type = "bas"
  instance      = "001"
}

module "naming_pip_firewall" {
  source        = "../../modules/naming"
  app           = "hub"
  env           = "prdx"
  region        = var.location
  resource_type = "pip"
  instance      = "001"
}

module "naming_pip_bastion" {
  source        = "../../modules/naming"
  app           = "hub"
  env           = "prdx"
  region        = var.location
  resource_type = "pip"
  instance      = "002"
}

module "naming_route_table" {
  source        = "../../modules/naming"
  app           = "hub"
  env           = "prdx"
  region        = var.location
  resource_type = "rt"
  instance      = "001"
}

# ---------------------------------------------------------------------------
# Resource group
# ---------------------------------------------------------------------------

resource "azurerm_resource_group" "hub" {
  name     = module.naming_rg.name
  location = var.location
  tags     = var.tags
}

# ---------------------------------------------------------------------------
# Public IPs
# ---------------------------------------------------------------------------

resource "azurerm_public_ip" "firewall" {
  name                = module.naming_pip_firewall.name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "bastion" {
  name                = module.naming_pip_bastion.name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# ---------------------------------------------------------------------------
# Hub Virtual Network
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network" "hub" {
  name                = module.naming_vnet.name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = var.hub_vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_prefix]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

# ---------------------------------------------------------------------------
# Azure Firewall
# ---------------------------------------------------------------------------

resource "azurerm_firewall" "hub" {
  name                = module.naming_firewall.name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# ---------------------------------------------------------------------------
# Azure Bastion
# ---------------------------------------------------------------------------

resource "azurerm_bastion_host" "hub" {
  name                = module.naming_bastion.name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = var.bastion_sku
  tags                = var.tags

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

# ---------------------------------------------------------------------------
# Route table (default route through firewall for spokes)
# ---------------------------------------------------------------------------

resource "azurerm_route_table" "spoke_default" {
  name                = module.naming_route_table.name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  tags                = var.tags

  route {
    name                   = "default-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }
}

# ---------------------------------------------------------------------------
# Private DNS zones
# ---------------------------------------------------------------------------

resource "azurerm_private_dns_zone" "zones" {
  for_each            = toset(var.private_dns_zone_names)
  name                = each.value
  resource_group_name = azurerm_resource_group.hub.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_links" {
  for_each              = azurerm_private_dns_zone.zones
  name                  = "${each.key}-hub-link"
  resource_group_name   = azurerm_resource_group.hub.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = false
}

# ---------------------------------------------------------------------------
# Diagnostic settings (send to Log Analytics)
# ---------------------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  name                       = "diag-firewall"
  target_resource_id         = azurerm_firewall.hub.id
  log_analytics_workspace_id = data.terraform_remote_state.management.outputs.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
