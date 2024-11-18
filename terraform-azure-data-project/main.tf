terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "azurerm" {
  features {}
}

module "azure" {
  source      = "./azure"
  environment = var.environment
}

/* module "databricks" {
  source              = "./databricks"
  resource_group_name = module.azure.resource_group_name
  location = module.azure.location
  environment = var.environment
} */