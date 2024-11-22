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
  name            = "ADBLinkedServiceViaMSI"
  data_factory_id = var.data_factory_id
  description     = "ADB Linked Service via MSI"
  adb_domain      = "https://${var.workspace_url}"

  msi_work_space_resource_id = var.workspace_id

  new_cluster_config {
    node_type             = "Standard_NC12"
    cluster_version       = "5.5.x-gpu-scala2.11"
    min_number_of_workers = 1
    max_number_of_workers = 4
    driver_node_type      = "Standard_NC12"
    log_destination       = "dbfs:/logs"
  }

}