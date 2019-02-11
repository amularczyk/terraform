resource "azurerm_network_security_group" "webapp" {
  name                = "WebAppSubnetSecurityGroup-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  security_rule {
    name                       = "Allow-Tcp-All"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80","443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "terraform" {
  name                = "VNET-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.vnet_ip}"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name            = "WebApp"
    address_prefix  = "${var.webapp_ip}"
    security_group  = "${azurerm_network_security_group.webapp.id}"
  }
}

output "virtual_network_name" {
  value = "${azurerm_virtual_network.terraform.name}"
}
