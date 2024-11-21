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

module "azure_resource_group" {
  source = "./modules/azure/resourcegroup"
}

module "azure_data_factory" {
  source                  = "./modules/azure/datafactory"
  resource_group_name     = module.azure_resource_group.resource_group_name
  resource_group_location = module.azure_resource_group.location
}