output "id" {
  description = "Resource ID of the container app environment."
  value       = azurerm_container_app_environment.this.id
}

output "name" {
  description = "Name of the container app environment."
  value       = azurerm_container_app_environment.this.name
}

output "default_domain" {
  description = "Default domain of the container app environment."
  value       = azurerm_container_app_environment.this.default_domain
}

output "static_ip_address" {
  description = "Static IP address of the container app environment."
  value       = azurerm_container_app_environment.this.static_ip_address
}
