output "spoke_vnet_id" {
  description = "Resource ID of the spoke virtual network."
  value       = azurerm_virtual_network.spoke.id
}

output "spoke_vnet_name" {
  description = "Name of the spoke virtual network."
  value       = azurerm_virtual_network.spoke.name
}

output "subnet_ids" {
  description = "Map of subnet names to their resource IDs."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "nsg_id" {
  description = "Resource ID of the spoke network security group."
  value       = azurerm_network_security_group.spoke.id
}

output "route_table_id" {
  description = "Resource ID of the spoke route table."
  value       = azurerm_route_table.spoke.id
}
