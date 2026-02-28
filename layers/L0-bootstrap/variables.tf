variable "subscription_id" {
  description = "Azure subscription ID for the bootstrap resources"
  type        = string
}

variable "region" {
  description = "Azure region for bootstrap resources"
  type        = string
  default     = "eastus"
}

variable "github_org" {
  description = "GitHub organization name for OIDC federated credentials"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name for OIDC federated credentials"
  type        = string
}

variable "state_container_names" {
  description = "Blob container names for each Terraform layer's state"
  type        = list(string)
  default = [
    "l0-bootstrap",
    "l1-governance",
    "l1-management",
    "l2-connectivity",
    "l2-cloudflare",
  ]
}

variable "service_principals" {
  description = "Map of service principal display names to create for OIDC"
  type        = map(string)
  default = {
    bootstrap    = "sp-tf-bootstrap"
    governance   = "sp-tf-governance"
    management   = "sp-tf-management"
    connectivity = "sp-tf-connectivity"
  }
}
