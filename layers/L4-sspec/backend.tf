terraform {
  backend "azurerm" {
    resource_group_name  = "platform-cicd-use1-rg-001"
    storage_account_name = "platformcicduse1st001"
    key                  = "terraform.tfstate"
    use_oidc             = true
    # container_name injected via: terraform init -backend-config="container_name=l4-sspec-stgx"
  }
}
