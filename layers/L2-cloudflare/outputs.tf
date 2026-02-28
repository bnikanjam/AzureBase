output "zone_id" {
  description = "Cloudflare zone ID for the primary domain."
  value       = cloudflare_zone.primary.id
}

output "nameservers" {
  description = "Cloudflare nameservers assigned to the zone."
  value       = cloudflare_zone.primary.name_servers
}
