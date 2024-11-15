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

# with this definition, you can define default values
# These default values will be overwriten if used additional variable file
variable "environment" {
  type        = string
  default     = "dev"
  description = "Default value for target environment"
}

resource "azurerm_resource_group" "tf-data-rg" {
  name     = "data-resources-${var.environment}"
  location = "Sweden Central"
}