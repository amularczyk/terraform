resource "azurerm_resource_group" "terraform" {
  name     = "${var.resource_group}"
  location = "West Europe"
}
