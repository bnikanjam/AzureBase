output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network."
  value       = azurerm_virtual_network.hub.name
}

output "hub_resource_group_name" {
  description = "Name of the hub resource group."
  value       = azurerm_resource_group.hub.name
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall."
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  description = "Public IP address of the Azure Firewall."
  value       = azurerm_public_ip.firewall.ip_address
}

output "bastion_id" {
  description = "Resource ID of the Azure Bastion host."
  value       = azurerm_bastion_host.hub.id
}

output "route_table_id" {
  description = "Resource ID of the spoke default route table."
  value       = azurerm_route_table.spoke_default.id
}

output "private_dns_zone_ids" {
  description = "Map of private DNS zone names to their resource IDs."
  value       = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
}

output "firewall_name" {
  description = "Name of the Azure Firewall."
  value       = azurerm_firewall.hub.name
}

output "firewall_resource_group_name" {
  description = "Resource group name containing the Azure Firewall."
  value       = azurerm_resource_group.hub.name
}
