resource "azurerm_storage_account" "tf-sa" {
  name                     = "sms${var.environment}swedencentralsa001"
  resource_group_name      = azurerm_resource_group.tf-data-rg.name
  location                 = azurerm_resource_group.tf-data-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}
