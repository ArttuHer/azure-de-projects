variable "environment" {
  type        = string
  description = "Default value for target environment"
}

resource "azurerm_resource_group" "tf-data-rg" {
  name     = "sms-resources-${var.environment}"
  location = "Sweden Central"

  tags = {
    environment = "sms-${var.environment}"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.tf-data-rg.name
}

output "location" {
  value = azurerm_resource_group.tf-data-rg.location
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

variable "layers" {
  description = "The layers for medallion architecture"
  type        = list(string)
  default     = ["bronze", "silver", "gold"]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "az-dl2" {
  name               = "${var.environment}-data"
  storage_account_id = azurerm_storage_account.tf-sa.id
}

resource "azurerm_storage_data_lake_gen2_path" "az-dl2-path" {
  for_each           = toset(var.layers)
  path               = "sms_${each.value}"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.az-dl2.name
  storage_account_id = azurerm_storage_account.tf-sa.id
  resource           = "directory"
}

resource "azurerm_databricks_workspace" "databricks-ws" {
  name                = "${var.environment}-databricks-ws"
  location            = azurerm_resource_group.tf-data-rg.location
  resource_group_name = azurerm_resource_group.tf-data-rg.name
  sku                 = "standard"

  tags = {
    environment = "${var.environment}"
  }
}