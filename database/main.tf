resource "azurerm_sql_server" "terraform" {
  name                = "terraform-mssql-${terraform.workspace}" 
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  version             = "12.0"
  administrator_login = "${var.username}"
  administrator_login_password = "${var.password}"
}

resource "azurerm_sql_elasticpool" "terraform" {
  name                = "terraform-elasticpool-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.terraform.name}"
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "terraform" {
  name                = "terraform-database-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.terraform.name}"
}

resource "azurerm_subnet" "terraform" {
  name                 = "SQL"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.subnet_ip}"
  service_endpoints    = ["Microsoft.Sql"]
}


resource "azurerm_network_security_group" "database" {
  name                = "DatabaseSubnetSecurityGroup-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  security_rule {
    name                       = "Allow-Subnet-Backend"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.backend_ip}"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "Deny-Internet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_subnet_network_security_group_association" "terraform" {
  subnet_id                 = "${azurerm_subnet.terraform.id}"
  network_security_group_id = "${azurerm_network_security_group.database.id}"
}