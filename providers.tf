variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

provider "azurerm" {
  version = "~> 1.21.0"
  subscription_id = "${var.subscription_id}"
  tenant_id = "${var.tenant_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
}

terraform {
  backend "azurerm" {
    storage_account_name = "terraform8"
    container_name = "terraform3"
    resource_group_name = "terraform-state"
    key = "terraform.tfstate"
  }
}