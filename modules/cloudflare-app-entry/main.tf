terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

resource "cloudflare_dns_record" "app" {
  zone_id = var.zone_id
  name    = var.app_subdomain
  type    = "A"
  content = var.origin_ip
  proxied = var.proxied
  ttl     = var.proxied ? 1 : 300
}
