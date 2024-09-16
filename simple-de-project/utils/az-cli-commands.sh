echo "Show current pipeline"

factory_name="contoso-customer-df"
pipeline_name="contoso-ingest-customer-data"
resource_group="DemoProjectsRG"

read -p "Do you want to show the pipeline information (yes/no): " input

if [[ "$input" == "yes" || "$input" == "y" ]]; then
  echo "Showing the pipeline $pipeline_name"
  az datafactory pipeline show --factory-name $factory_name --name $pipeline_name --resource-group $resource_group
else
  echo "The pipeline information is not showed"
fi

read -p "Do you want to run the pipeline (yes/no): " input

if [[ "$input" == "yes" || "$input" == "y" ]]; then
  echo "Running the pipeline $pipeline_name"
  az datafactory pipeline create-run --resource-group $resource_group --name $pipeline_name --factory-name $factory_name
else
  echo "The pipeline is not started"
fi