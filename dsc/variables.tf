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
  default = "https://we-agentservice-prod-1.azure-automation.net/accounts/b675921d-17d0-4d0d-94b7-89dbb588c77a"
}

variable "registration_key" {
  default = "f512f/gHM7YLYKBNhfhcyYEuhIlfvp2cTRvAB2fF9t95aBFnbQ2K6ZjYaXlmpBVEyYG1A9liTOe20bDpE4c2Tg=="
}