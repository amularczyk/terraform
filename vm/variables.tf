variable "resource_group_name" {}

variable "location" {}

variable "virtual_network_name" {}

variable "service_principal_object_id" {}

variable "subnet_ip" {
  type = "string"
  default = "10.0.2.0/24"
}