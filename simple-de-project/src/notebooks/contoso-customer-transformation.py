# Databricks notebook source
# MAGIC %md
# MAGIC ## Imports

# COMMAND ----------

# MAGIC %md
# MAGIC ## Functions

# COMMAND ----------

########## Mounting
def mount_data_location():
    """
    Mount new locations with this functions. This is a one time operation.
    Note that GitHub can't store secret keys, so you will need to hard code them in the mount_data_location function
    """
    configs = {"fs.azure.account.auth.type": "OAuth",
    "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id": "",
    "fs.azure.account.oauth2.client.secret": "",
    "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/4e471800-b214-428e-893a-cf1b98f96007/oauth2/token"}


    dbutils.fs.mount(
    source = "abfss://contoso-data@contosocustomerdata.dfs.core.windows.net", # contrainer@storageacc
    mount_point = "/mnt/contoso-customer/",
    extra_configs = configs)

########## Write/Load
def read_data(path, delimiter):
    """
    Read data from Bronze
    """
    return spark.read.option("delimiter",delimiter).option("header", True).csv(path)

def write_data_to_location(df, write_mode, target_path):
    """
    Write data to Silver
    """
    df.write.format("csv").mode(write_mode).option("header",True).save(target_path)


# COMMAND ----------

# MAGIC %md
# MAGIC ## Variable definitions

# COMMAND ----------

mounted_location = "/mnt/contoso-customer/"
source_folder = "bronze_github_contoso_customer"

table_name = "contoso_customers"
target_folder = "silver_github_contoso_customer"

# COMMAND ----------

# MAGIC %md
# MAGIC ## Data ingestion & Mounting

# COMMAND ----------

mounted = True
if not mounted:
    mount_data_location()
else:
    print("Mount point already exists")

# COMMAND ----------

source_path = f"{mounted_location}{source_folder}/{table_name}.csv"
print(f"Using: {source_path}")
contoso_customer_data = read_data(source_path, ",")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Transformations

# COMMAND ----------

# MAGIC %md
# MAGIC ## Load data to ADLS

# COMMAND ----------

target_path = f"{mounted_location}{target_folder}/{table_name}"
write_data_to_location(contoso_customer_data, "overwrite", target_path)
