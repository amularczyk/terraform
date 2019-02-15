variable "name" {}

variable "resource_group_name" {}

variable "location" {}

variable "node_configuration_name" {}

variable "virtual_machine_name" {}

variable "computer_name" {}

variable "configuration_url" {
  default = "https://terraform8.blob.core.windows.net/automation/DscMetaConfigs.zip"
}

variable "script_name" {
  default = "DscMetaConfigs.ps1"
}

variable "function_name" {
  default = "DscMetaConfigs"
}

variable "registration_url" {
}

variable "registration_key" {
}