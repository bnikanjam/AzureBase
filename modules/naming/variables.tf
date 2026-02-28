variable "app" {
  description = "Application or workload short name (e.g., hub, myapp, platform)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{1,19}$", var.app))
    error_message = "App name must be lowercase alphanumeric, start with a letter, and be 2-20 characters."
  }
}

variable "env" {
  description = "Environment 4-character code (e.g., prdx, stgx, devx, cicd)"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{4}$", var.env))
    error_message = "Environment must be exactly 4 lowercase letters."
  }
}

variable "region" {
  description = "Azure region name (e.g., eastus, westus2, westeurope)"
  type        = string
}

variable "resource_type" {
  description = "CAF resource type abbreviation (e.g., vnet, afw, rg, kv, ca, cae, st, nsg, log, bas, pip)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{0,9}$", var.resource_type))
    error_message = "Resource type must be lowercase alphanumeric, start with a letter, and be 1-10 characters."
  }
}

variable "instance" {
  description = "Instance number as a 3-digit string (e.g., 001, 002)"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{3}$", var.instance))
    error_message = "Instance must be exactly 3 digits (e.g., 001)."
  }
}
