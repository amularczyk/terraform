variable "resource_group" {
  type = "string"
  default = "terraform"
}

variable "vnet_ip" {
  type = "string"
  default = "10.0.0.0/16"
}

variable "webapp_ip" {
  type = "string"
  default = "10.0.1.0/24"
}

variable "backend_ip" {
  type = "string"
  default = "10.0.2.0/24"
}

variable "database_ip" {
  type = "string"
  default = "10.0.3.0/24"
}