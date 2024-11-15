variable "environment" {
  type        = string
  description = "Default value for target environment"
}

resource "azurerm_resource_group" "tf-data-rg" {
  name     = "data-resources-${var.environment}"
  location = "Sweden Central"
}