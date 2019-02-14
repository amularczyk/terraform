variable "resource_group_name" {}

variable "location" {}

variable "vnet_ip" {
  type = "string"
  default = "10.0.0.0/16"
}