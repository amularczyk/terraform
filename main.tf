resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group}-${terraform.workspace}"
  location = "West Europe"
}

# terraform workspace new env