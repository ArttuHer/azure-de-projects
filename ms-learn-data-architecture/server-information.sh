az configure --defaults group=ms-learn-rg sql-server=logisticss-db-dev
az sql db list
az sql db list | jq '[.[] | {name: .name}]'
