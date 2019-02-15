resource "azurerm_subnet" "webapp" {
  name                 = "Webapp"
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
    subnet_id                     = "${azurerm_subnet.webapp.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm.id}"
  }
}

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
  subnet_id                 = "${azurerm_subnet.webapp.id}"
  network_security_group_id = "${azurerm_network_security_group.webapp.id}"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "terraform-vm-${terraform.workspace}"
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.location}"
  network_interface_ids = ["${azurerm_network_interface.terraform.id}"]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  storage_data_disk {
    name              = "myosdisk2"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  os_profile {
    computer_name  = "${var.computer_name}"
    admin_username = "vmadmin"
    admin_password = "${var.password}"
  }

  os_profile_windows_config  {
    enable_automatic_upgrades = false
    provision_vm_agent = true
  }
}


output "virtual_machine_name" {
  value = "${azurerm_virtual_machine.vm.name}"
}

output "computer_name" {
  value = "${var.computer_name}"
}
