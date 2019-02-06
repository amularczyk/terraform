variable "resource_group_name" {}

variable "location" {}

variable "virtual_network_name" {}

variable "sql_ip" {
  type = "string"
  default = "10.0.4.0/24"
}