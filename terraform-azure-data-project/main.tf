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

module "azure" {
  source      = "./modules/azure"
  environment = var.environment
}