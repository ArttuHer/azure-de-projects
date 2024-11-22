variable "data_factory_id" {
  description = "Data factory id"
  type        = string
}

variable "databricks_url" {
  description = "Databricks workspace url"
  type        = string
}

resource "azurerm_data_factory_linked_service_azure_databricks" "databricks" {
  name            = "ADBLinkedServiceViaMSI"
  data_factory_id = var.data_factory_id
  description     = "ADB Linked Service via MSI"
  adb_domain      = "https://${var.databricks_url}"
}