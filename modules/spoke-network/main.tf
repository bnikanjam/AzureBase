terraform {
  required_version = "~> 1.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.62.0"
    }
  }
}

# ---------------------------------------------------------------------------
# Naming
# ---------------------------------------------------------------------------

module "naming_vnet" {
  source        = "../naming"
  app           = var.spoke_name
  env           = var.env
  region        = var.location
  resource_type = "vnet"
  instance      = "001"
}

module "naming_nsg" {
  source        = "../naming"
  app           = var.spoke_name
  env           = var.env
  region        = var.location
  resource_type = "nsg"
  instance      = "001"
}

module "naming_route_table" {
  source        = "../naming"
  app           = var.spoke_name
  env           = var.env
  region        = var.location
  resource_type = "rt"
  instance      = "001"
}

# ---------------------------------------------------------------------------
# Spoke Virtual Network
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network" "spoke" {
  name                = module.naming_vnet.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.spoke_vnet_address_space
  tags                = var.tags
}

# ---------------------------------------------------------------------------
# Subnets
# ---------------------------------------------------------------------------

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = each.value.address_prefixes
}

# ---------------------------------------------------------------------------
# NSG (shared across spoke subnets)
# ---------------------------------------------------------------------------

resource "azurerm_network_security_group" "spoke" {
  name                = module.naming_nsg.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "spoke" {
  for_each                  = azurerm_subnet.subnets
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.spoke.id
}

# ---------------------------------------------------------------------------
# Route table (default route via firewall)
# ---------------------------------------------------------------------------

resource "azurerm_route_table" "spoke" {
  name                = module.naming_route_table.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  route {
    name                   = "default-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "spoke" {
  for_each       = azurerm_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.spoke.id
}

# ---------------------------------------------------------------------------
# VNet peering: spoke -> hub
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "${azurerm_virtual_network.spoke.name}-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  allow_virtual_network_access = true
}

# ---------------------------------------------------------------------------
# VNet peering: hub -> spoke
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "hub-to-${azurerm_virtual_network.spoke.name}"
  resource_group_name          = var.hub_resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  allow_virtual_network_access = true
}
