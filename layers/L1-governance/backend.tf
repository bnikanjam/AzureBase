terraform {
  backend "azurerm" {
    resource_group_name  = "platform-cicd-use1-rg-001"
    storage_account_name = "platformcicduse1st001"
    container_name       = "l1-governance"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}
