resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group}-${terraform.workspace}"
  location = "West Europe"
}

# module "serviceprincipal" {
#   source                = "./serviceprincipal"
# }

module "vnet" {
  source                = "./vnet"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  location              = "${azurerm_resource_group.terraform.location}"
}

module "keyvault" {
  source                      = "./keyvault"
  resource_group_name         = "${azurerm_resource_group.terraform.name}"
  location                    = "${azurerm_resource_group.terraform.location}"
  #service_principal_object_id = "${module.serviceprincipal.object_id}"
  service_principal_object_id = ""
}

module "vm" {
  source                      = "./vm"
  resource_group_name         = "${azurerm_resource_group.terraform.name}"
  location                    = "${azurerm_resource_group.terraform.location}"
  virtual_network_name        = "${module.vnet.virtual_network_name}"
  password                    = "${module.keyvault.password}"
}

module "backend" {
  source                      = "./backend"
  resource_group_name         = "${azurerm_resource_group.terraform.name}"
  location                    = "${azurerm_resource_group.terraform.location}"
  virtual_network_name        = "${module.vnet.virtual_network_name}"
  webapp_ip                   = "${module.vm.webapp_ip}"
}

module "database" {
  source                = "./database"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  location              = "${azurerm_resource_group.terraform.location}"
  virtual_network_name  = "${module.vnet.virtual_network_name}"
  #username              = "${module.serviceprincipal.client_id}"
  username              = "username"
  password              = "${module.keyvault.password}"
  backend_ip            = "${module.backend.backend_ip}"
}
