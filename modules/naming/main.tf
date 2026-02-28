terraform {
  required_version = ">= 1.9, < 2.0"
}

locals {
  # Resource types that require no hyphens and have character limits
  no_hyphen_resources = toset(["st", "kv"])

  # Maximum character lengths for restricted resources
  max_lengths = {
    "st" = 24
    "kv" = 24
  }

  # Standard name with hyphens
  standard_name = "${var.app}-${var.env}-${local.region_code}-${var.resource_type}-${var.instance}"

  # Name without hyphens for restricted resources
  compact_name = "${var.app}${var.env}${local.region_code}${var.resource_type}${var.instance}"

  # Determine if this resource type needs special handling
  needs_compact = contains(local.no_hyphen_resources, var.resource_type)

  # Apply length truncation for restricted resources
  truncated_name = local.needs_compact ? substr(local.compact_name, 0, min(length(local.compact_name), local.max_lengths[var.resource_type])) : local.standard_name

  # Final resource name
  resource_name = local.truncated_name
}
