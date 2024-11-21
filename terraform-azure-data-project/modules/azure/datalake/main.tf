variable "environment" {
  type        = string
  description = "Default value for target environment"
}

variable "storage_account_id" {
  description = "Storage account id"
  type        = string
}

variable "layers" {
  description = "The layers for medallion architecture"
  type        = list(string)
  default     = ["bronze", "silver", "gold"]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "az-dl2" {
  name               = "${var.environment}-data"
  storage_account_id = var.storage_account_id
}

resource "azurerm_storage_data_lake_gen2_path" "az-dl2-path" {
  for_each           = toset(var.layers)
  path               = "sms_${each.value}"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.az-dl2.name
  storage_account_id = var.storage_account_id
  resource           = "directory"
}