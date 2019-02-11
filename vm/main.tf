resource "azurerm_subnet" "terraform" {
  name                 = "SQL"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.subnet_ip}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_interface" "terraform" {
  name                = "terraform-network-interface"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.terraform.id}"
    private_ip_address_allocation = "dynamic"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "terraform" {
  name                = "terraform-vault-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  enabled_for_disk_encryption = true
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }
}

resource "azurerm_key_vault_access_policy" "main" {
  vault_name          = "${azurerm_key_vault.terraform.name}"
  resource_group_name = "${azurerm_key_vault.terraform.resource_group_name}"

  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  #object_id = "${data.azurerm_client_config.current.service_principal_object_id}"
  object_id = "5afbc374-b391-4c63-bd64-7deb080e0487"

  secret_permissions = [
    "get",
    "list",
    "set",
  ]
}

resource "azurerm_key_vault_access_policy" "child" {
  vault_name          = "${azurerm_key_vault.terraform.name}"
  resource_group_name = "${azurerm_key_vault.terraform.resource_group_name}"

  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  object_id = "${var.service_principal_object_id}"

  secret_permissions = [
    "get",
  ]
}

resource "random_id" "server" {
  keepers = {
    ami_id = 2
  }
  byte_length = 8
}

resource "azurerm_key_vault_secret" "terraform" {
  name      = "terraform-vm-${terraform.workspace}"
  value     = "${random_id.server.hex}aA1!"
  vault_uri = "${azurerm_key_vault.terraform.vault_uri}"
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
    admin_username = "testadmin"
    admin_password = "${random_id.server.hex}aA1!"
  }

  os_profile_windows_config  {
    # disable_password_authentication = false
  }
}