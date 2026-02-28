variable "name" {
  description = "Name of the container app."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "container_app_environment_id" {
  description = "Resource ID of the container app environment."
  type        = string
}

variable "registry_server" {
  description = "FQDN of the container registry (e.g. myacr.azurecr.io)."
  type        = string
}

variable "image" {
  description = "Container image name and tag (e.g. myapp:latest)."
  type        = string
}

variable "cpu" {
  description = "CPU cores allocated to the container."
  type        = string
  default     = "0.5"
}

variable "memory" {
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

variable "env_vars" {
  description = "Map of environment variable names to values."
  type        = map(string)
  default     = {}
}

variable "identity_ids" {
  description = "List of user-assigned managed identity resource IDs."
  type        = list(string)
}

variable "revision_mode" {
  description = "Revision mode for the container app (Single or Multiple)."
  type        = string
  default     = "Single"
}

variable "tags" {
  description = "Tags to apply to the container app."
  type        = map(string)
  default     = {}
}
