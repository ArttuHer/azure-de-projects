variable "environment" {
  type        = string
  description = "Default value for target environment"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

resource "azurerm_storage_account" "tf-sa" {
  name                     = "sms${var.environment}swedencentralsa001"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

output "storage_account_id" {
  value = azurerm_storage_account.tf-sa.id
}