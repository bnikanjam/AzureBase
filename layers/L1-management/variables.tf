variable "state_resource_group_name" {
  description = "Resource group containing the Terraform state storage account"
  type        = string
}

variable "state_storage_account_name" {
  description = "Storage account name for Terraform remote state"
  type        = string
}

variable "location" {
  description = "Azure region for management resources"
  type        = string
}

variable "management_subscription_id" {
  description = "Azure subscription ID for the management resources"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Number of days to retain logs in Log Analytics workspace"
  type        = number
  default     = 30
}
