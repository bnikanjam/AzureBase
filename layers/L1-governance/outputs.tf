# ---------------------------------------------------------------------------
# Management group IDs
# ---------------------------------------------------------------------------

output "management_group_ids" {
  description = "Map of management group names to their resource IDs."
  value       = module.alz.management_group_resource_ids
}

output "management_group_names" {
  description = "Map of management group names to their display names."
  value       = module.alz.management_group_display_names
}

output "management_subscription_id" {
  description = "Subscription ID placed in the Management management group."
  value       = var.management_subscription_id
}

output "connectivity_subscription_id" {
  description = "Subscription ID placed in the Connectivity management group."
  value       = var.connectivity_subscription_id
}

output "identity_subscription_id" {
  description = "Subscription ID placed in the Identity management group."
  value       = var.identity_subscription_id
}
