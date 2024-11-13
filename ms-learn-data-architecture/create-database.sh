SERVERNAME=fitnesssqlserver-1998

# Define the resource group name (ensure it exists or create it beforehand)
RESOURCE_GROUP=mslearn-rg

# Define the location (e.g., eastus, westus, etc.)
LOCATION=swedencentral

# Define the SQL server admin username
ADMIN_LOGIN=ServerAdmin

# Define the SQL server admin password (must meet Azure's complexity requirements)
PASSWORD=Tero1000

az sql db create \
--resource-group $RESOURCE_GROUP \
--server $SERVERNAME \
--name fitnessespoodb \
--max-size 2GB

az sql db create \
--resource-group $RESOURCE_GROUP \
--server $SERVERNAME \
--name fitnesslahtidb \
--max-size 2GB


