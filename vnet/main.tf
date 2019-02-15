resource "azurerm_virtual_network" "terraform" {
  name                = "VNET-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.vnet_ip}"]
}

output "virtual_network_name" {
  value = "${azurerm_virtual_network.terraform.name}"
}
