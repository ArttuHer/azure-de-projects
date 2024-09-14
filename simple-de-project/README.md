### Project description

Contoso Electrics wants to analyse their customer data, which is stored in a JSON format in GitHub. Data engineer should provide Gold level data for data analysts to answer the questions posed by the management. In gold data, data should fullfill the following criteria: 
1. Customer is alive (she has SSN)
2. Customer is a natural person (Not Business ID)
3. Valid contract with Contoso 
4. Phone number in format 358 50 111 1111

### Project outcome
At the end of the project, data analysts should be able to answer the following questions: 
1. Do we have a list of phone numbers where send message in a case of electricity outgages? 
2. How many phone numbers we are missing? 

### Services
The following services are used. As a disclaimer, one could done this project only with, for example, Databricks, but for learning purposes different services are used: 
- Azure Data Factory
  - Data ingestion
- Azure Data Lake Gen 2
  - Data Storage
- Azure Databricks
  - Transformations
- Azure Synapse Analytics
  - Analytical queries