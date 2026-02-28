# ---------------------------------------------------------------------------
# Cloudflare
# ---------------------------------------------------------------------------

variable "domain" {
  description = "Primary domain name to manage in Cloudflare (e.g. example.com)."
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID."
  type        = string
}

# ---------------------------------------------------------------------------
# State backend variables (used by terraform_remote_state for L2-connectivity)
# ---------------------------------------------------------------------------

variable "state_resource_group_name" {
  description = "Resource group containing the Terraform state storage account."
  type        = string
}

variable "state_storage_account_name" {
  description = "Storage account name for Terraform remote state."
  type        = string
}
