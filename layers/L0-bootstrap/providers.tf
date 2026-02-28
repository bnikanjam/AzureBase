terraform {
  required_version = "= 1.14.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.62.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 3.8.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {}
