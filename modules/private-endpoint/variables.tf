variable "name" {
  description = "Name of the private endpoint."
  type        = string
}

variable "location" {
  description = "Azure region for the private endpoint."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "Resource ID of the subnet to place the private endpoint in."
  type        = string
}

variable "private_connection_resource_id" {
  description = "Resource ID of the target service to connect to."
  type        = string
}

variable "subresource_names" {
  description = "List of subresource names for the private service connection."
  type        = list(string)
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs for automatic DNS registration."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the private endpoint."
  type        = map(string)
  default     = {}
}
