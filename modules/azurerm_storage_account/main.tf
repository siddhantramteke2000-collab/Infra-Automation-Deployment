resource "azurerm_storage_account" "stg" {
  name                     = var.stg-name
  location                 = var.stg-location
  resource_group_name      = var.rg-name
  account_tier             = var.acc-tier
  account_replication_type = var.acc-type
}
