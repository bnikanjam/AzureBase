output "id" {
  description = "Resource ID of the container app."
  value       = azurerm_container_app.this.id
}

output "name" {
  description = "Name of the container app."
  value       = azurerm_container_app.this.name
}

output "fqdn" {
  description = "Fully qualified domain name of the container app."
  value       = azurerm_container_app.this.ingress[0].fqdn
}

output "latest_revision_name" {
  description = "Name of the latest revision of the container app."
  value       = azurerm_container_app.this.latest_revision_name
}
