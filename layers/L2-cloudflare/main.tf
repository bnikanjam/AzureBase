# ---------------------------------------------------------------------------
# Remote state -- read L2-connectivity outputs for firewall public IP
# ---------------------------------------------------------------------------

data "terraform_remote_state" "connectivity" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "l2-connectivity"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

# ---------------------------------------------------------------------------
# Cloudflare Zone
# ---------------------------------------------------------------------------

resource "cloudflare_zone" "primary" {
  account = {
    id = var.cloudflare_account_id
  }
  name = var.domain
}

# ---------------------------------------------------------------------------
# SSL / TLS settings
# ---------------------------------------------------------------------------

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = cloudflare_zone.primary.id
  setting_id = "ssl"
  value      = "strict"
}

resource "cloudflare_zone_setting" "min_tls_version" {
  zone_id    = cloudflare_zone.primary.id
  setting_id = "min_tls_version"
  value      = "1.2"
}

resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = cloudflare_zone.primary.id
  setting_id = "always_use_https"
  value      = "on"
}

# ---------------------------------------------------------------------------
# WAF -- Managed Rulesets (zone-level entry point)
# ---------------------------------------------------------------------------

resource "cloudflare_ruleset" "waf_managed" {
  zone_id     = cloudflare_zone.primary.id
  name        = "Managed WAF rulesets"
  description = "Deploy Cloudflare Managed and OWASP Core rulesets"
  kind        = "zone"
  phase       = "http_request_firewall_managed"

  rules = [
    {
      ref         = "execute_cloudflare_managed_ruleset"
      description = "Execute Cloudflare Managed Ruleset"
      expression  = "true"
      action      = "execute"
      action_parameters = {
        id = "efb7b8c949ac4650a09736fc376e9aee"
      }
    },
    {
      ref         = "execute_cloudflare_owasp_core_ruleset"
      description = "Execute Cloudflare OWASP Core Ruleset"
      expression  = "true"
      action      = "execute"
      action_parameters = {
        id = "4814384a9e5d4991b9815dcfc25d2f1f"
      }
    },
  ]
}

# ---------------------------------------------------------------------------
# Root DNS A record -- points to Azure Firewall public IP (proxied)
# ---------------------------------------------------------------------------

resource "cloudflare_dns_record" "root" {
  zone_id = cloudflare_zone.primary.id
  name    = "@"
  type    = "A"
  content = data.terraform_remote_state.connectivity.outputs.firewall_public_ip
  proxied = true
  ttl     = 1 # Auto when proxied
}
