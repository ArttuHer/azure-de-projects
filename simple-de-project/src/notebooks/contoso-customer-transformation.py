# Databricks notebook source
# MAGIC %md
# MAGIC ## Imports

# COMMAND ----------

from pyspark.sql import functions as F

# COMMAND ----------

# MAGIC %md
# MAGIC ## Functions

# COMMAND ----------

########## Transformations
def find_natural_persons(df, column, regex_pattern):
    """
    Find natural persons from the data based on SSN. 
    Drop legal persons (companies) from the data.
    """
    df_with_natural_persons = df.withColumn("valid_ssn", F.col(column).rlike(regex_pattern))
    df_with_natural_persons = df_with_natural_persons.filter(F.col("valid_ssn") == True)
    return df_with_natural_persons.drop("valid_ssn")

def check_that_customer_is_alive(df):
    """
    Customer is alive when she has a valid SSN number
    """
    df_filtered = df.filter(F.col("customer_id").isNotNull())
    print(f"Dropped {df.count() - df_filtered.count()} records where customer was not alive")
    return df_filtered

def check_that_customer_has_contract(df):
    """
    Check that customer has contract
    """
    df_filtered = df.filter(F.col("contract_number").isNotNull())
    print(f"Dropped {df.count() - df_filtered.count()} records where customer did not have a valid contract")
    return df_filtered

def check_mobile_phone_number(df, column):
  """
  Filter rows where "Puhelinnumero" is either an empty string or None type
  """
  return df.filter(~((F.col(column) == "") | F.col(column).isNull()))

def convert_phone_number_to_asked_format(df, criteria):
    """
    Pass regex pattern, replace and column to modify. 
    """
    for criteria_key, criteria_value in criteria.items():
        df = df.withColumn("phone_number", F.regexp_replace(F.col("phone_number"), criteria_key, criteria_value))
    return df


def handle_phone_number_transformations(df, criteria):
    """
    Filter rows where "Puhelinnumero" is either an empty string or None type.
    """
    df_filtered_empty_phone_numbers = check_mobile_phone_number(df, "phone_number")
    print(f"Records after filtering empty phone numbers: {df_filtered_empty_phone_numbers.count()}")

    df_formatted_phone_numbers = convert_phone_number_to_asked_format(df_filtered_empty_phone_numbers, criteria)
    return df_formatted_phone_numbers

def create_age_from_ssn(df, ssn_column, age_column):
    """
    This function parses birthday from SSN-number and calculates the age. 
    Statistics Finland has defined different characteristics that define the century https://stat.fi/meta/kas/hetu.html#:~:text=Muoto%20PPKKVVXNNNT%2C%20jossa%20PPKKVV%3Dsyntym%C3%A4aika,I%2C%20O%2CQ).
    """
    df = df.withColumn("day", F.substring(F.col(ssn_column), 1,2))
    df = df.withColumn("month", F.substring(F.col(ssn_column), 3,2))
    df = df.withColumn("year_suffix", F.substring(F.col(ssn_column), 5,2))
    df = df.withColumn(
        "century",
        F.when(
            (F.col(ssn_column).contains("-")) |
            (F.col(ssn_column).contains("Y")) |
            (F.col(ssn_column).contains("X")) |
            (F.col(ssn_column).contains("W")) |
            (F.col(ssn_column).contains("V")) |
            (F.col(ssn_column).contains("U")),
            "19"
        ).when(
            F.col(ssn_column).contains("+"), 
            "18"
        ).otherwise("20")
    )
    df = df.withColumn("year", F.concat(F.col("century"), F.lit(""), F.col("year_suffix")))
    df = df.withColumn(
        "birth_day", 
        F.concat(F.col("year"), F.lit("-"), F.col("month"), F.lit("-"), F.col("day"))
    )
    df = df.withColumn("birth_day", F.to_date(F.col("birth_day"), "yyyy-MM-dd"))

    df = df.withColumn(
        age_column,
        F.floor(
            F.datediff(F.current_date(), F.col("birth_day")) / 365.25 # The average length of of a Gregorian calendar is 365.25 days
        )
    )
    df = df.drop("day", "month", "year_suffix", "century", "year", "birth_day", ssn_column)
    return df

def convert_additional_languagues_to_english(df, column_name):
    """
    If there are languagues are not in fi, se and en, convert them to en. 
    Use tilde operator to make reverse "isin" argument
    """
    print("Chaning all other languague preferences to be English.")
    
    other_languague_count = df.filter(~F.col(column_name).isin("en", "se", "fi")).count() 
    print(f"Changed records: {other_languague_count} ")
    return df.withColumn(column_name,
        F.when(~F.col(column_name).isin("fi", "se", "en"), "en").otherwise(F.col(column_name)))

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

print(f"Ingested {contoso_customer_data.count()} records")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Transformations

# COMMAND ----------

# Keep only natural persons that are alive

ssn_pattern = r'(\d{6}-\d{4}|\d{6}-\d{3}[A-Z]|\d{6}[A-Z]\d{3}[A-Z]|\d{6}[A-Z]\d{4}|\d{6}\+\d{4})'
contoso_customer_data_natural_persons = find_natural_persons(contoso_customer_data, column="customer_id", regex_pattern=ssn_pattern)
contoso_customer_data_natural_persons = check_that_customer_is_alive(contoso_customer_data_natural_persons)

# COMMAND ----------

contoso_customer_data_natural_persons = check_that_customer_has_contract(contoso_customer_data_natural_persons)

regex_criteria = {"[+\s]":"", "^0":"358"}
contoso_customer_data_valid_phone_numbers = handle_phone_number_transformations(contoso_customer_data_natural_persons, regex_criteria)

# COMMAND ----------

contoso_customer_data_with_age = create_age_from_ssn(contoso_customer_data_valid_phone_numbers, ssn_column="customer_id", age_column="age")

# COMMAND ----------

contoso_customer_data_with_valid_languague = convert_additional_languagues_to_english(contoso_customer_data_with_age, column_name="languague")

# COMMAND ----------

contoso_customer_data_silver = contoso_customer_data_with_valid_languague.drop("contract_number")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Load data to ADLS

# COMMAND ----------

target_path = f"{mounted_location}{target_folder}/{table_name}"
print(target_path)

write_data_to_location(contoso_customer_data_silver, "overwrite", target_path)
