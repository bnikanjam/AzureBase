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

variable "connectivity_subscription_id" {
  description = "Azure subscription ID for connectivity resources."
  type        = string
}

variable "location" {
  description = "Azure region for hub networking resources."
  type        = string
  default     = "eastus"
}

# ---------------------------------------------------------------------------
# Hub VNet configuration
# ---------------------------------------------------------------------------

variable "hub_vnet_address_space" {
  description = "Address space for the hub virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for the AzureFirewallSubnet."
  type        = string
  default     = "10.0.0.0/26"
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for the AzureBastionSubnet."
  type        = string
  default     = "10.0.0.64/26"
}

variable "gateway_subnet_prefix" {
  description = "Address prefix for the GatewaySubnet."
  type        = string
  default     = "10.0.0.128/27"
}

# ---------------------------------------------------------------------------
# Firewall & Bastion configuration
# ---------------------------------------------------------------------------

variable "firewall_sku_tier" {
  description = "SKU tier for Azure Firewall (Standard or Premium)."
  type        = string
  default     = "Standard"
}

variable "bastion_sku" {
  description = "SKU for Azure Bastion (Basic or Standard)."
  type        = string
  default     = "Standard"
}

# ---------------------------------------------------------------------------
# Private DNS zones
# ---------------------------------------------------------------------------

variable "private_dns_zone_names" {
  description = "List of private DNS zone names to create for PaaS private endpoints."
  type        = list(string)
  default = [
    "privatelink.azurecr.io",
    "privatelink.vaultcore.azure.net",
    "privatelink.blob.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.azurewebsites.net",
  ]
}

# ---------------------------------------------------------------------------
# Tags
# ---------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
