resource "azurerm_subnet" "backend" {
  name                 = "Backend"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.backend_ip}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_security_group" "backend" {
  name                = "BackendSubnetSecurityGroup-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  security_rule {
    name                       = "Allow-Subnet-Backend"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.webapp_ip}"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "terraform" {
  subnet_id                 = "${azurerm_subnet.backend.id}"
  network_security_group_id = "${azurerm_network_security_group.backend.id}"
}

output "backend_ip" {
  value = "${var.backend_ip}"
}