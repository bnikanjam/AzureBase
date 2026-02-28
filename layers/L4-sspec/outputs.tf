output "app_url" {
  description = "Public URL of the application."
  value       = "https://${var.app_subdomain}.${var.domain}"
}

output "aca_fqdn" {
  description = "Fully qualified domain name of the container app."
  value       = module.container_app.fqdn
}

output "spoke_vnet_id" {
  description = "Resource ID of the spoke virtual network."
  value       = module.spoke.spoke_vnet_id
}

output "container_app_id" {
  description = "Resource ID of the container app."
  value       = module.container_app.id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}
