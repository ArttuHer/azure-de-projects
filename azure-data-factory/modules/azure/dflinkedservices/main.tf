variable "data_factory_id" {
  description = "Data factory id"
  type        = string
}

variable "workspace_url" {
  description = "Databricks workspace url"
  type        = string
}

variable "workspace_id" {
  description = "Databricks workspace id"
  type        = string
}

resource "azurerm_data_factory_linked_service_azure_databricks" "databricks" {
  name                = "LS_databricks"
  data_factory_id     = var.data_factory_id
  description         = "ADB Linked Service via MSI"
  existing_cluster_id = "1122-071514-jfedgut"

  msi_work_space_resource_id = var.workspace_id
  adb_domain                 = "https://${var.workspace_url}"
}