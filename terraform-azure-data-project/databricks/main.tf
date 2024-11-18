variable "resource_group_name" {
  description = "The name of the resource group to deploy the Databricks workspace"
  type        = string
}

variable "location" {
  description = "The location of the Databricks workspace"
  type        = string
}

variable "environment" {
  type        = string
  description = "Default value for target environment"
}