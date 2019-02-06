resource "azurerm_sql_server" "terraform" {
    name = "terraform-mssql-${terraform.workspace}" 
    resource_group_name = "${azurerm_resource_group.terraform.name}"
    location = "${azurerm_resource_group.terraform.location}"
    version = "12.0"
    administrator_login = "4dm1n157r470r"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_elasticpool" "terraform" {
  name                = "terraform-elasticpool-${terraform.workspace}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"
  location            = "${azurerm_resource_group.terraform.location}"
  server_name         = "${azurerm_sql_server.terraform.name}"
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "terraform" {
  name                = "terraform-database-${terraform.workspace}"
  resource_group_name = "${azurerm_resource_group.terraform.name}"
  location            = "${azurerm_resource_group.terraform.location}"
  server_name         = "${azurerm_sql_server.terraform.name}"
}

resource "azurerm_subnet" "terraform" {
  name                 = "SQL"
  resource_group_name  = "${azurerm_resource_group.terraform.name}"
  virtual_network_name = "${azurerm_virtual_network.terraform.name}"
  address_prefix       = "${var.sql_ip}"
  service_endpoints    = ["Microsoft.Sql"]
}