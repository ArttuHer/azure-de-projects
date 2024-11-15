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

variable "environment" {
  type        = string
  default     = "dev"
  description = "Specify the target environment"
}

resource "azurerm_resource_group" "tf-data-rg" {
  name     = "data-resources-${var.environment}"
  location = "Sweden Central"
}