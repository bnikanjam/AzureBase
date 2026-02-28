variable "zone_id" {
  description = "Cloudflare zone ID where the DNS record will be created."
  type        = string
}

variable "app_subdomain" {
  description = "Subdomain for the application (e.g. 'api', 'app', 'www')."
  type        = string
}

variable "origin_ip" {
  description = "Origin IP address for the DNS record (A record content)."
  type        = string
}

variable "proxied" {
  description = "Whether the DNS record is proxied through Cloudflare."
  type        = bool
  default     = true
}
