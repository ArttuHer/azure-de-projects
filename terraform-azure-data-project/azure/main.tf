variable "environment" {
  type        = string
  description = "Default value for target environment"
}

resource "azurerm_resource_group" "tf-data-rg" {
  name     = "data-resources-${var.environment}"
  location = "Sweden Central"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_account" "tf-sa" {
  name                     = "sms${var.environment}swedencentralsa001"
  resource_group_name      = azurerm_resource_group.tf-data-rg.name
  location                 = azurerm_resource_group.tf-data-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "az-dl2" {
  name               = "${var.environment}-bronze"
  storage_account_id = azurerm_storage_account.tf-sa.id
}

resource "azurerm_storage_data_lake_gen2_path" "az-dl2-path" {
  path               = "bronze"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.az-dl2.name
  storage_account_id = azurerm_storage_account.tf-sa.id
  resource           = "directory"
}