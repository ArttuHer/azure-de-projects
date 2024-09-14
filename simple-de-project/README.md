### Disclaimer
All the data used in this project is pseudodata and created with the following tools:
- SSN: https://www.lintukoto.net/muut/henkilotunnus/
- Business ID: https://telepartikkeli.azurewebsites.net/tunnusgeneraattori

### Project description

Contoso Bank wants to analyse their customer data, which is stored in a JSON format in GitHub. Data engineer should provide data for data analysts to answer the questions posed by the management. The data should fullfill the following criteria: 
1. Customer is alive (she has SSN)
2. Customer is a natural person (Not Business ID)
3. Valid contract with Contoso (Has a contract number)
4. Phone number with Finnish country code

### Project outcome
At the end of the project, data analysts should be able to answer the following questions: 
1. Do we have a list of phone numbers where send message in a case of service outgages? 
2. How many phone numbers we are missing? 

### Data description
In the data, we have the following columns. Customer id is either SSN or business id, phone number is in any format and contract number is a number which was created when the account was opened. 
```json
{
  "customer_id": {},
  "phone_number": {},
  "contract_number": {}, 
}
```

### Azure services
The following services are used. As a note, one could done this project only with, for example, Databricks, but for learning purposes different services are used: 
- Azure Data Factory
  - Data ingestion
- Azure Data Lake Gen 2
  - Data Storage
- Azure Databricks
  - Transformations
- Azure Synapse Analytics
  - Analytical queries

## 
