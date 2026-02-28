output "dns_record_id" {
  description = "ID of the created Cloudflare DNS record."
  value       = cloudflare_dns_record.app.id
}

output "hostname" {
  description = "Full hostname for the application DNS record."
  value       = cloudflare_dns_record.app.name
}
