variable "name" {
  description = "Name of the container app environment."
  type        = string
}

variable "location" {
  description = "Azure region for the container app environment."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "Resource ID of the infrastructure subnet for the environment."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace for diagnostics."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the container app environment."
  type        = map(string)
  default     = {}
}
