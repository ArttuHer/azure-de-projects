terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.58.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
}

module "azure_resource_group" {
  source      = "./modules/azure/resourcegroup"
  environment = var.environment
}

module "azure_storage_account" {
  source                  = "./modules/azure/storageaccount"
  environment             = var.environment
  resource_group_name     = module.azure_resource_group.resource_group_name
  resource_group_location = module.azure_resource_group.location
}

module "azure_data_lake_gen2" {
  source             = "./modules/azure/datalake"
  environment        = var.environment
  storage_account_id = module.azure_storage_account.storage_account_id
}
