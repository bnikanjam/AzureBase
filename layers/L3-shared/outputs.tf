output "acr_id" {
  description = "Resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.shared.id
}

output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry."
  value       = azurerm_container_registry.shared.login_server
}

output "acr_name" {
  description = "Name of the Azure Container Registry."
  value       = azurerm_container_registry.shared.name
}

output "spoke_vnet_id" {
  description = "Resource ID of the shared spoke virtual network."
  value       = module.spoke_network.spoke_vnet_id
}
