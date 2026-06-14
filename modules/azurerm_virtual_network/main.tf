resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet-name
  location            = var.vnet-location
  resource_group_name = var.rg-name
  address_space       = var.address_space
}
