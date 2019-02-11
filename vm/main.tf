resource "azurerm_subnet" "backend" {
  name                 = "Backend"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.subnet_ip}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_public_ip" "vm" {
  name                = "terraform-ip-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "terraform" {
  name                = "terraform-network-interface"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.backend.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm.id}"
  }
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
    source_address_prefix      = "${var.subnet_ip}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Rdp"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "terraform" {
  subnet_id                 = "${azurerm_subnet.backend.id}"
  network_security_group_id = "${azurerm_network_security_group.backend.id}"
}

resource "azurerm_virtual_machine" "terraform" {
  name                  = "terraform-vm-${terraform.workspace}"
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.location}"
  network_interface_ids = ["${azurerm_network_interface.terraform.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "terraform-${terraform.workspace}"
    admin_username = "vmadmin"
    admin_password = "${var.password}"
  }

  os_profile_windows_config  {
    # disable_password_authentication = false
  }
}

output "backend_ip" {
  value = "${var.subnet_ip}"
}
