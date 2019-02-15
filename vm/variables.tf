variable "resource_group_name" {}

variable "location" {}

variable "virtual_network_name" {}

variable "password" {}

variable "subnet_ip" {
  type = "string"
  default = "10.1.1.0/24"
}

variable "computer_name" {
  default = "terraform"
}

variable "configuration_url" {
  default = "https://terraform8.blob.core.windows.net/automation2/DscMetaConfigs.zip"
}
variable "script_name" {
  default = "DscMetaConfigs.ps1"
}
variable "function_name" {
  default = "DscMetaConfigs"
}
variable "registration_url" {
  default = ""
}
variable "registration_key" {
  default = ""
}
variable "conde_configuration_name" {
  default = "InstallIIS.localhost"
}