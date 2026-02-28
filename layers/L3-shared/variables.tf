# ---------------------------------------------------------------------------
# State backend variables (used by terraform_remote_state)
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
# Subscription & region
# ---------------------------------------------------------------------------

variable "subscription_id" {
  description = "Azure subscription ID for shared resources."
  type        = string
}

variable "location" {
  description = "Azure region for shared resources."
  type        = string
  default     = "eastus"
}

# ---------------------------------------------------------------------------
# ACR configuration
# ---------------------------------------------------------------------------

variable "acr_sku" {
  description = "SKU for Azure Container Registry."
  type        = string
  default     = "Premium"
}

# ---------------------------------------------------------------------------
# Tags
# ---------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
