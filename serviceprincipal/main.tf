resource "azurerm_azuread_application" "terraform" {
  name                       = "terraform-${terraform.workspace}"
  identifier_uris            = ["http://uri"]
  reply_urls                 = ["http://replyurl"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azurerm_azuread_service_principal" "terraform" {
  application_id = "${azurerm_azuread_application.terraform.application_id}"
}

# data "azurerm_client_config" "current" {}

# # Is it needed to set this role?
# resource "azurerm_role_assignment" "test" {
#   scope                = "${data.azurerm_client_config.current.subscription_id }"
#   role_definition_name = "Contributor"
#   principal_id         = "${azurerm_azuread_service_principal.terraform.id}"
# }

output "client_id" {
  value = "${azurerm_azuread_service_principal.terraform.application_id}"
}

output "object_id" {
  value = "${azurerm_azuread_service_principal.terraform.id}"
}
