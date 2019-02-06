provider "azurerm" {
  version = "~> 1.21.0"
}

terraform {
  backend "azurerm" {
    storage_account_name = "terraform8"
    container_name = "terraform2"
    resource_group_name = "terraform-state"
    key = "terraform.tfstate"
  }
}
