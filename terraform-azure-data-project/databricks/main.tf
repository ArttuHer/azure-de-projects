variable "resource_group_name" {
  description = "The name of the resource group to deploy the Databricks workspace"
  type        = string
}

variable "location" {
  description = "The location of the Databricks workspace"
  type        = string
}

variable "environment" {
  type        = string
  description = "Default value for target environment"
}

resource "azurerm_databricks_workspace" "databricks-ws" {
  name                = "databricks-ws-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "standard"

  tags = {
    environment = "${var.environment}"
  }
}