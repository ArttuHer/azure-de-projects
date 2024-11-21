resource "azurerm_resource_group" "tf-data-rg" {
  name     = "data-factory-resources"
  location = "Sweden Central"

  tags = {
    environment = "data-factory"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.tf-data-rg.name
}

output "location" {
  value = azurerm_resource_group.tf-data-rg.location
}