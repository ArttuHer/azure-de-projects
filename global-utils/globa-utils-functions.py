# Databricks notebook source
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

