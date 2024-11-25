variable "data_factory_id" {
  description = "Data factory id"
  type        = string
}

resource "azurerm_data_factory_pipeline" "test" {
  name            = "run-train-volume-transformations"
  data_factory_id = var.data_factory_id

  activities_json = <<JSON
[
  {
    "name": "run-notebook",
    "type": "DatabricksNotebook",
    "dependsOn": [],
    "policy": {
        "timeout": "0.12:00:00",
        "retry": 0,
        "retryIntervalInSeconds": 30,
        "secureOutput": false,
        "secureInput": false
    },
    "userProperties": [],
    "typeProperties": {
        "notebookPath": "/Users/arttu.heroja@gmail.com/azure-de-projects/azure-data-factory/notebooks/stat-finland"
    },
    "linkedServiceName": {
        "referenceName": "LS_databricks",
        "type": "LinkedServiceReference"
    }
  }
]
  JSON
}