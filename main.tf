resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group}-${terraform.workspace}"
  location = "West Europe"
}

#terraform workspace new env

module "serviceprincipal" {
  source                = "./serviceprincipal"
}

module "vnet" {
  source                = "./vnet"
  resource_group_name   = "${azurerm_resource_group.terraform.name}"
  location              = "${azurerm_resource_group.terraform.location}"
}

# module "database" {
#   source                = "./database"
#   resource_group_name   = "${azurerm_resource_group.terraform.name}"
#   location              = "${azurerm_resource_group.terraform.location}"
#   virtual_network_name  = "${module.vnet.virtual_network_name}"
#   client_id             = "${module.serviceprincipal.client_id}"
#   client_secret         = "${module.serviceprincipal.client_secret}"
# }

module "vm" {
  source                      = "./vm"
  resource_group_name         = "${azurerm_resource_group.terraform.name}"
  location                    = "${azurerm_resource_group.terraform.location}"
  virtual_network_name        = "${module.vnet.virtual_network_name}"
  service_principal_object_id = "${module.serviceprincipal.object_id}"
}
