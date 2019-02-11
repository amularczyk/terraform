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
    "delete",
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
    ami_id = 1
  }
  byte_length = 8
}

locals {
  password = "${random_id.server.hex}A!"
}

resource "azurerm_key_vault_secret" "terraform" {
  name      = "terraform-vm-${terraform.workspace}"
  value     = "${local.password}"
  vault_uri = "${azurerm_key_vault.terraform.vault_uri}"
}

output "password" {
  value = "${local.password}"
}
