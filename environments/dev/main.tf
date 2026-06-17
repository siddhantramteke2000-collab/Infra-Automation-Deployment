module "azurerm_resource_group" {
  source      = "../../modules/azurerm_resource_group"
  for_each    = var.rg
  rg-name     = each.value.name
  rg-location = each.value.location
}

module "azurerm_storage_account" {
  source       = "../../modules/azurerm_storage_account"
  depends_on   = [module.azurerm_resource_group]
  for_each     = var.stg
  stg-name     = each.value.name
  stg-location = each.value.location
  rg-name      = each.value.resource_group_name
  acc-tier     = each.value.account_tier
  acc-type     = each.value.account_replication_type
}

module "azurerm_virtual_network" {
  source        = "../../modules/azurerm_virtual_network"
  depends_on    = [module.azurerm_resource_group]
  for_each      = var.vnet
  vnet-name     = each.value.name
  vnet-location = each.value.location
  rg-name       = each.value.resource_group_name
  address_space = each.value.address_space
}

module "azurerm_subnet" {
  source           = "../../modules/azurerm_subnet"
  depends_on       = [module.azurerm_resource_group, module.azurerm_virtual_network]
  for_each         = var.subnet
  sub-name         = each.value.name
  rg-name          = each.value.resource_group_name
  vn-name          = each.value.virtual_network_name
  address_prefixes = each.value.address_prefixes
}

module "azurerm_network_security_group" {
  source              = "../../modules/azurerm_nsg"
  depends_on          = [module.azurerm_resource_group]
  for_each            = var.nsg
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

module "azurerm_network_interface" {
  source                        = "../../modules/azurerm_nic"
  depends_on                    = [module.azurerm_resource_group, module.azurerm_subnet]
  for_each                      = var.nic
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  ip_name                       = each.value.ip_name
  private_ip_address_allocation = each.value.private_ip_address_allocation
  subnet_id                     = module.azurerm_subnet[each.value.subnet_key].subnet_id
}

