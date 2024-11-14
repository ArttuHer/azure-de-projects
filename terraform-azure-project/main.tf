terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mtc-rg" {
  name     = "mtc-resources"
  location = "Sweden Central"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "mtc-vm" {
  name = "mtc-network"
  resource_group_name = azurerm_resource_group.mtc-rg.name
  location = azurerm_resource_group.mtc-rg.location
  address_space = ["10.123.0.0/16"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "mtc-subnet" {
  name = "mtc-subnet-1"
  resource_group_name = azurerm_resource_group.mtc-rg.name
  location = azurerm_resource_group.mtc-rg.location
  virtual_network_name = azurerm_resource_group.mtc-vm.name
  address_prefixes = ["10.0.1.0/24"]
}