variable "spoke_name" {
  description = "Short name for the spoke (used in naming module as the app prefix)."
  type        = string
}

variable "env" {
  description = "Environment 4-character code (e.g., prdx, stgx, devx)."
  type        = string
  default     = "prdx"
}

variable "location" {
  description = "Azure region for the spoke resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to create spoke resources in."
  type        = string
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network."
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group name of the hub virtual network."
  type        = string
}

variable "spoke_vnet_address_space" {
  description = "Address space for the spoke virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet configurations for the spoke VNet."
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {}
}

variable "firewall_private_ip" {
  description = "Private IP address of the hub Azure Firewall for default route."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all spoke resources."
  type        = map(string)
  default     = {}
}
