variable "resource_group_name" {}

variable "location" {}

variable "virtual_network_name" {}

variable "subnet_ip" {
  type = "string"
  default = "10.0.3.0/24"
}

variable "client_id" {}

variable "client_secret" {}