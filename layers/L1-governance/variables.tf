# ---------------------------------------------------------------------------
# State backend variables (used by terraform_remote_state for L0-bootstrap)
# ---------------------------------------------------------------------------

variable "state_resource_group_name" {
  description = "Resource group containing the Terraform state storage account."
  type        = string
}

variable "state_storage_account_name" {
  description = "Storage account name for Terraform remote state."
  type        = string
}

# ---------------------------------------------------------------------------
# ALZ module configuration
# ---------------------------------------------------------------------------

variable "location" {
  description = "Default Azure region for resources."
  type        = string
  default     = "eastus"
}

variable "tenant_root_management_group_display_name" {
  description = "Display name for the tenant root management group used by the ALZ hierarchy."
  type        = string
  default     = "Azure Landing Zones"
}

variable "management_subscription_id" {
  description = "Subscription ID for the Management landing zone."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Subscription ID for the Connectivity landing zone."
  type        = string
}

variable "identity_subscription_id" {
  description = "Subscription ID for the Identity landing zone."
  type        = string
  default     = ""
}

variable "architecture_name" {
  description = "ALZ architecture name to deploy (e.g. 'alz')."
  type        = string
  default     = "alz"
}
