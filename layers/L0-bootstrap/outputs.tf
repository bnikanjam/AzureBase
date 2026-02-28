output "resource_group_name" {
  description = "Name of the resource group containing state storage"
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "Name of the storage account for Terraform state"
  value       = azurerm_storage_account.state.name
}

output "state_container_names" {
  description = "Map of blob container names for each layer's state"
  value       = { for k, v in azurerm_storage_container.state : k => v.name }
}

output "oidc_client_ids" {
  description = "Map of service principal keys to their application (client) IDs"
  value       = { for k, v in azuread_application.oidc : k => v.client_id }
}

output "oidc_service_principal_ids" {
  description = "Map of service principal keys to their object IDs"
  value       = { for k, v in azuread_service_principal.oidc : k => v.object_id }
}
