variable "resource_group_name" {}

variable "location" {}

variable "virtual_network_name" {}

variable "password" {}

variable "subnet_ip" {
  type = "string"
  default = "10.0.1.0/24"
}


variable "configuration_url" {
  default = "https://terraform8.blob.core.windows.net/automation2/DscMetaConfigs.zip"
}
variable "script_name" {
  default = "DscMetaConfig.zip"
}
variable "function_name" {
  default = "DscMetaConfig"
}
variable "registration_url" {
  default = "https://we-agentservice-prod-1.azure-automation.net/accounts/b675921d-17d0-4d0d-94b7-89dbb588c77a"
}
variable "registration_key" {
  default = "YcsLa7qG/QmNpeNL3KBQL+C6SuVhOtWyl4U5ngl9QnH9W0ztrTl9WJ2YjbFTS5hexk0+6aNZEPZ1aGwS6SCZfg=="
}
variable "conde_configuration_name" {
  default = "InstallIIS"
}