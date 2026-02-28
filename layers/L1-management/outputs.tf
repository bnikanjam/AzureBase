output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace"
  value       = module.alz_management.log_analytics_workspace.id
}

output "automation_account_id" {
  description = "Resource ID of the Automation account"
  value       = module.alz_management.automation_account.id
}

output "resource_group_name" {
  description = "Name of the management resource group"
  value       = azurerm_resource_group.management.name
}
