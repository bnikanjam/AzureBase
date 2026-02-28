terraform {
  required_version = "= 1.14.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.62.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.management_subscription_id
  use_oidc        = true
}
