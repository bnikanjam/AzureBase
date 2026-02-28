# Uncomment the backend block below after the initial apply.
# The first run uses local state to create the storage account,
# then you migrate state into the newly-created backend.
#
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "platform-cicd-use1-rg-001"
#     storage_account_name = "platformcicduse1st001"
#     container_name       = "l0-bootstrap"
#     key                  = "terraform.tfstate"
#   }
# }
