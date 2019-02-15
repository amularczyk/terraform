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

module "dsc-iis" {
  source                      = "./dsc"
  name                        = "iis"
  resource_group_name         = "${azurerm_resource_group.terraform.name}"
  location                    = "${azurerm_resource_group.terraform.location}"
  node_configuration_name     = "InstallIIS.localhost"
  virtual_machine_name        = "${module.vm.virtual_machine_name}"
  computer_name               = "${module.vm.computer_name}"
}

module "dsc-disk" {
  source                      = "./dsc"
  name                        = "disk"
  resource_group_name         = "${azurerm_resource_group.terraform.name}"
  location                    = "${azurerm_resource_group.terraform.location}"
  node_configuration_name     = "DataDisk.localhost"
  virtual_machine_name        = "${module.vm.virtual_machine_name}"
  computer_name               = "${module.vm.computer_name}"
}
