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