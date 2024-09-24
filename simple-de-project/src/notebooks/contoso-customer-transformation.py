# Databricks notebook source
mounted = True
 
 # store these secrets under Azure key vault, for happy path, define them here. 
if not mounted:
    configs = {"fs.azure.account.auth.type": "OAuth",
    "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id": "",
    "fs.azure.account.oauth2.client.secret": "",
    "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/4e471800-b214-428e-893a-cf1b98f96007/oauth2/token"}


    dbutils.fs.mount(
    source = "abfss://contoso-data@contosocustomerdata.dfs.core.windows.net", # contrainer@storageacc
    mount_point = "/mnt/contoso-customer/",
    extra_configs = configs)
else:
    print("Mount point already exists")
