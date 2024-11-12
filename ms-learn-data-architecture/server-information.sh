az configure --defaults group=ms-learn-rg sql-server=logisticss-db-dev
az sql db list
az sql db list | jq '[.[] | {name: .name}]'
sqlcmd -S tcp:logisticss-db-dev.database.windows.net,1433 -d Logistics -U <username> -P <password> -N -l 30
group delete --name <resourcegroup>
