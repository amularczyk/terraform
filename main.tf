resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group}-${terraform.workspace}"
  location = "West Europe"
}

module "database" {
  source                = "./database"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  location              = "${azurerm_resource_group.terraform.location}"
  virtual_network_name  = "${azurerm_virtual_network.terraform.name}"
}

# terraform workspace new env