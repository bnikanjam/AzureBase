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
  description = "Azure subscription ID for sspec workload resources."
  type        = string
}

variable "hub_subscription_id" {
  description = "Azure subscription ID for the hub/connectivity resources (firewall DNAT)."
  type        = string
}

variable "location" {
  description = "Azure region for sspec resources."
  type        = string
  default     = "eastus"
}

# ---------------------------------------------------------------------------
# Application
# ---------------------------------------------------------------------------

variable "app_name" {
  description = "Short name for the application workload."
  type        = string
  default     = "sspec"
}

variable "env" {
  description = "Environment 4-character code (e.g. stgx, prdx)."
  type        = string
}

variable "domain" {
  description = "Primary domain name (e.g. example.com)."
  type        = string
}

variable "app_subdomain" {
  description = "Subdomain for the application (e.g. sspec-staging, sspec)."
  type        = string
}

# ---------------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------------

variable "spoke_address_space" {
  description = "Address space for the spoke virtual network."
  type        = list(string)
}

variable "aca_subnet_prefix" {
  description = "Address prefix for the ACA infrastructure subnet (minimum /23)."
  type        = string
}

variable "pe_subnet_prefix" {
  description = "Address prefix for the private endpoints subnet."
  type        = string
}

# ---------------------------------------------------------------------------
# Container App
# ---------------------------------------------------------------------------

variable "container_image" {
  description = "Container image name and tag (e.g. sspec:latest)."
  type        = string
}

variable "container_cpu" {
  description = "CPU cores allocated to the container."
  type        = string
  default     = "0.5"
}

variable "container_memory" {
  description = "Memory allocated to the container."
  type        = string
  default     = "1Gi"
}

variable "min_replicas" {
  description = "Minimum number of container replicas."
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of container replicas."
  type        = number
  default     = 3
}

variable "target_port" {
  description = "Port the container listens on for ingress traffic."
  type        = number
  default     = 8080
}

# ---------------------------------------------------------------------------
# Cloudflare
# ---------------------------------------------------------------------------

variable "cloudflare_api_token" {
  description = "Cloudflare API token for DNS management."
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------
# Tags
# ---------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
