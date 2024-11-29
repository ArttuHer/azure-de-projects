# Databricks notebook source
# MAGIC %md
# MAGIC ## Import utils functions

# COMMAND ----------

from pyspark.sql.types import StructType, StructField, StringType
from pyspark.sql import DataFrame
import re
import requests
import csv
from io import StringIO

# COMMAND ----------

# MAGIC %md
# MAGIC ## Variables

# COMMAND ----------

url_trains = 'https://pxdata.stat.fi:443/PxWeb/api/v1/fi/StatFin/rtie/statfin_rtie_pxt_12ra.px'

# COMMAND ----------

query_passenger_traffic = {
  "query": [
    {
      "code": "Vuosineljännes",
      "selection": {
        "filter": "item",
        "values": [
          "2019Q1",
          "2019Q2",
          "2019Q3",
          "2019Q4",
          "2020Q1",
          "2020Q2",
          "2020Q3",
          "2020Q4",
          "2021Q1",
          "2021Q2",
          "2021Q3",
          "2021Q4",
          "2022Q1",
          "2022Q2",
          "2022Q3",
          "2022Q4",
          "2023Q1",
          "2023Q2",
          "2023Q3",
          "2023Q4",
          "2024Q1",
          "2024Q2"
        ]
      }
    },
    {
      "code": "Tiedot",
      "selection": {
        "filter": "item",
        "values": [
          "hliiklkm"
        ]
      }
    }
  ],
  "response": {
    "format": "csv"
  }
}

# COMMAND ----------

# MAGIC %md
# MAGIC ## Query

# COMMAND ----------

response = requests.post(url_trains, json=query_passenger_traffic)
response.raise_for_status()
csv_data = response.text
csv_file = StringIO(csv_data)
csv_reader = csv.reader(csv_file)

# COMMAND ----------



# COMMAND ----------

# MAGIC %md
# MAGIC ## Extract to list format

# COMMAND ----------

train_data_list = []
for row in csv_reader:
    # Process the data as needed
    train_data_list += row

# COMMAND ----------

columns = []
for index in range(0,2):
    columns.append(train_data_list[index])
print(columns)

# COMMAND ----------

print(train_data_list)
