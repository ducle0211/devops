
/// Network security group
resource "azurerm_network_security_group" "network_scg" {
  location            = var.location
  name                = "security-group-${var.resource_group}"
  resource_group_name = var.resource_group
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

/// Vitual network and Subnet 
resource "azurerm_virtual_network" "vitual_network" {
  address_space       = ["10.0.0.0/8"]
  location            = var.location
  name                = "${var.resource_group}-vnet"
  resource_group_name = var.resource_group
  depends_on = [
    azurerm_resource_group.rg,
  ]
} 

/// Network rule
resource "azurerm_network_security_rule" "network_rule1" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "In_Port_80"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 310
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule3" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Outbound"
  name                        = "Port_80"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 120
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule7" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}
