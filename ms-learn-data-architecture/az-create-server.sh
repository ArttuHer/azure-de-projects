iaz group list --output table

SERVERNAME="fitnesssqlserver-1998"

# Define the resource group name (ensure it exists or create it beforehand)
RESOURCE_GROUP="mslearn-rg"

# Define the location (e.g., eastus, westus, etc.)
LOCATION="swedencentral"

# Define the SQL server admin username
ADMIN_LOGIN="ServerAdmin"

# Define the SQL server admin password (must meet Azure's complexity requirements)
PASSWORD="Tero1000"

az sql server create --name $SERVERNAME --resource-group $RESOURCE_GROUP --location $LOCATION --admin-user $ADMIN_LOGIN --admin-password $PASSWORD
az sql server list --resource-group  --output table

