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

resource "azurerm_databricks_workspace" "databricks-ws" {
  name                = "${var.environment}-databricks-ws"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "standard"

  tags = {
    environment = "${var.environment}"
  }
}

output "workspace_url" {
  value = azurerm_databricks_workspace.databricks-ws.workspace_url
}