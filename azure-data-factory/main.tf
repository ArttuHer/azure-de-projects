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

module "databricks_workspace" {
  source                  = "./modules/azure/databricksws"
  environment             = var.environment
  resource_group_name     = module.azure_resource_group.resource_group_name
  resource_group_location = module.azure_resource_group.location
}

module "datafactory_linked_service" {
  source          = "./modules/azure/dflinkedservices"
  environment     = var.environment
  data_factory_id = module.azure_data_factory.data_factory_id
}