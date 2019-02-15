resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group}-${terraform.workspace}"
  location = "West Europe"
}

module "vnet" {
  source                = "./vnet"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  location              = "${azurerm_resource_group.terraform.location}"
}

module "vm" {
  source                      = "./vm"
  resource_group_name         = "${azurerm_resource_group.terraform.name}"
  location                    = "${azurerm_resource_group.terraform.location}"
  virtual_network_name        = "${module.vnet.virtual_network_name}"
  password                    = "Password111!"
}
