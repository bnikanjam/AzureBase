terraform {
  required_version = "= 1.14.6"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "= 2.8.0"
    }
    alz = {
      source  = "azure/alz"
      version = "= 0.20.2"
    }
  }
}

provider "azapi" {
  use_oidc = true
}

provider "alz" {}
