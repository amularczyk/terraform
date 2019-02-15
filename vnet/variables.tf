variable "resource_group_name" {}

variable "location" {}

variable "vnet_ip" {
  type = "string"
  default = "10.1.0.0/16"
}