variable "resource_group_name" {}

variable "location" {}

variable "virtual_network_name" {}


variable "webapp_ip" {}

variable "backend_ip" {
  type = "string"
  default = "10.0.2.0/24"
}