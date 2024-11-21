variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

resource "azurerm_data_factory" "az-df" {
  name                = "data-factory-basics-001"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

output "data_factory_id" {
  value = azurerm_data_factory.az-df.id
}