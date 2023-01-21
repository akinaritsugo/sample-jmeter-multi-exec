resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prj}-${var.env}-main-vnet"
  address_space       = ["172.16.0.0/20"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet configuration
resource "azurerm_subnet" "master" {
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "master-subnet"
  address_prefixes     = ["172.16.0.0/24"]
}
resource "azurerm_subnet_network_security_group_association" "master" {
  subnet_id                 = azurerm_subnet.master.id
  network_security_group_id = azurerm_network_security_group.master.id
}

resource "azurerm_subnet" "slave" {
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "slave-subnet"
  address_prefixes     = ["172.16.1.0/24"]
}
resource "azurerm_subnet_network_security_group_association" "slave" {
  subnet_id                 = azurerm_subnet.slave.id
  network_security_group_id = azurerm_network_security_group.slave.id
}

# Network Security Group
resource "azurerm_network_security_group" "master" {
  name                = "${var.prj}-${var.env}-main-vnet-master-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "slave" {
  name                = "${var.prj}-${var.env}-main-vnet-slave-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
