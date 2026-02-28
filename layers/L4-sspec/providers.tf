terraform {
  required_version = "= 1.14.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.62.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 5.17.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  use_oidc        = true
}

provider "azurerm" {
  alias = "hub"
  features {}
  subscription_id = var.hub_subscription_id
  use_oidc        = true
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
