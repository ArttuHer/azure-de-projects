<div align="center">
  <div id="user-content-toc">
    <ul>
      <summary><h1 style="display: inline-block;">ETL project on Azure</h1></summary>
    </ul>
  </div>
</div>
<br>


### Disclaimer
All the data used in this project is pseudodata and created with the following tools:
- SSN: https://www.lintukoto.net/muut/henkilotunnus/
- Business ID: https://telepartikkeli.azurewebsites.net/tunnusgeneraattori

#### Relevant links
- Kanban: [link to Miro board](https://miro.com/app/board/uXjVLejWrWU=/)

### Project Objective

Contoso Bank wants to analyse their customer data, which is stored in CSV format in GitHub. Data engineer should provide data for data analysts to answer the questions posed by the management. 

#### Project Outcome
At the end of the project, data analysts should be able to answer the following questions: 
1. Do we have a list of phone numbers by preferred languague where send message in a case of service outgages? 
2. How many customers are using Finnish, English or Swedish as their preferred languague?

#### Data Criteria
In order to answer the questions, the data should fullfill the following criteria: 
1. Customer is alive (she has SSN)
2. Customer is a natural person (Not Business ID)
3. Valid contract with Contoso (Has a contract number)
4. Phone number with Finnish country code

#### Data Description
In the data, we have the following information: 
- **Customer ID**: This can either be a Social Security Number (SSN) or a Business ID.
- **Phone Number**: Provided in various formats.
- **Contract Number**: A unique number generated when the account was opened.
- **Language Preference**: The preferred language for customer communications.

Schema
```json
{
  "customer_id": "",
  "phone_number": "",
  "contract_number": "",
  "languague": ""
}
```

### Used Services and Architecture

#### 🛠️ Technologies Used
The following services are used. As a note, one could done this project only with, e.g. Azure Synapse Analytics, but for learning purposes different services are used: 
- Azure Data Factory
  - Data ingestion
- Azure Data Lake Gen 2
  - Data Storage
- Azure Databricks
  - Transformations
- Azure Synapse Analytics
  - Analytical queries

#### 📝 Architecture Diagram
![Architecture Diagram](res/azure_de_project_architecture.jpg)

1. Data is located in the project repository
2. Copy data from GitHub to Azure Data Factory
3. Store ingested Bronze data to Azure Data Lake
4. Make transformations with PySpark in Azure Databricks platform
5. Store Silver data to Azure Data Lake
6. Run analytical queries in Azure Synapse Analytics



## Implementation Steps 

**Create Storage Account and Resource Group**

First thing to do is to create a storage account and link it to project specific resource group. Azure storage account stores your data objects, such as BLOBs and files, whereas resource group is a logical container for your resources. More information can be found from Microsoft's learning portal [About storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal) and [About resource groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group)

**Create container for data**

Create container for your data under storage account. Give it a name and create folders for Bronze and Silver data. The following naming convention was used: `<level>_<source_system>_<object>` like bronze_github_contoso_customer. Naming was inspired by Databricks [Databricks community](https://community.databricks.com/t5/data-engineering/best-practices-around-bronze-silver-gold-medallion-model-data/m-p/26045/highlight/true#M18170)

**Create Azure Data factory**

Create Azure Data factory. Give it a name, region and link it to resource group which was created previously. More information can be found here [Quickstart: Create a data factory by using the Azure portal](https://learn.microsoft.com/en-us/azure/data-factory/quickstart-create-data-factory)

**Ingest Bronze data with Data factory to Data Lake**

Ingest data from the source. In this project we are using a simple pipeline with copy action. Define required parameters to ingest data via HTTP as csv-format and store it to Bronze data location. Tutorial on how to copy data via HTTP calls [Copy data from an HTTP endpoint by using Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/connector-http?tabs=data-factory)

**Create Azure Databricks service**
Like in Data factory, find Azure Databricks service, link it to your project resource group, fill the other information if needed and deploy it. After the deployment, launch the service and create compute cluster. More information about clusters here: [About cluster configurations](https://learn.microsoft.com/en-us/azure/databricks/compute/configure)

**Mount Azure Data Lake storage to the Data factory/Transformations**
In Azure portal, go to App registrations and select new registration. After registration, copy client and tenant IDs. Then, new client secret need to be created. Mounting has been done with this Python script: [Utils notebook](https://github.com/ArttuHer/azure-de-projects/blob/main/global-utils/globa-utils-functions.py). After mounting, you can ingest the Bronze data and make Spark-based transformations to it. The following transformations has been done: [Transformation notebook](https://github.com/ArttuHer/azure-de-projects/blob/main/simple-de-project/src/notebooks/contoso-customer-transformation.py)

**Create Synapse Analytics service**
The UI of Azure Synapse Analytics (SA) is similar than Data Factory and therefore, you can find similar selections from there. Link your Silver layer data to your SA workspace and you can query the data. More information on Microsoft's learning portal [Ingest data into Azure Data Lake Storage Gen2](https://learn.microsoft.com/en-us/azure/synapse-analytics/data-integration/data-integration-data-lake)

## Comparison of Used Services
In any project, it is important to consider the architectural choises and compare the used services with one another. Hence, in this chapter, the selected services will be compared to
### Azure Data Lake Storage Gen2 vs Azure Blob Storage 

#### Purpose and usage

Blob Storage
- Generated for storing large amounts of unstructured data, like audio and text files
- Can be described as a general purpose object storage

ADLS Gen2
- ADLS Gen2 is designed for analytics and data processing
- Easy integration with other analytics tools, like Azure Synapse Analytics and Azure Databricks

#### Namespace structure 

Blob Storage
- Blob storage uses a flat namespace, instead of hierarchical namespace
- Each blob is referenced by a unique URL

ADLS Gen2
- ADLS Gen2 uses hierarchical namespace (HNS), which creates a structure for handling data
- HNS is similar than a folder structure in a traditional file system

#### Access control

Blob Storage
- Access through storage account
- Access control is usually less granular than in ADLS Gen2, due to flat namespace
- Permissions at the container and account level

ADLS Gen2
- Access through storage account
- Permission can be given at a folder level
- Suitable for cases, where there is a large data team that need an access to different parts of the dataset

#### Integration with Analytical Tools

Blob Storage
- Lack specific optimisation for analytics workloads
- Less efficient when using distributed processing tools, without additional layers

ADLS Gen2
- Native integration with analytics tools
- Good performance with batch processing, streaming data and complex data transformations

#### When to Use Which?

Use Azure Blob Storage when you need: 
- A simple and scalable storage for general purpose use (e.g., backups and file storage)
- No requirements on complex analytics or file operations

Use Azure Data Lake Storage Gen2 when you need: 
- Complex analytics and have large data sets in hand
- Integration with big data tools like Apache Spark
- A more granular access control and a hierarchical namespace for better data management

### Azure Data Factory (ADF) vs Azure Databricks
#### Purpose and usage
ADF
- Designed for moving data from one place to another and to orchestrate data movement and transformations
- The basic-idea is low-code, as developers can map workflows easily with graphical user interface (drag-and-drop features)

Databricks
- A unified platform for ML, data science and data engineering with a focus on large-scale data processing
- It is based on Apache Spark, which is a good tool for processing large-scale data

#### Integration with Analytical Tools
ADF
- Supports many connectors, including Azure services, on-premises and other third-party systems

Databricks
- Offers Spark as a service, which reduces configuration work before processing the data
- Can be linked to many cloud services
- Integration focuses mainly on Azure Data Lake and Delta lake
- Has less connector options

#### Development and collaboration
ADF
- A visual interface for designing workflows and pipelines
- Good for developers with minimal coding experience
- Pipeline collaboration can be integrated with Git

Databricks
- Notebook-based development that support Python, R, SQL and Scala
- Suitable for more complex use cases
- Real-time collaboration is easy with Git integration

#### Performance
ADF
- Scales automatically based on workload
- Does not have a native compute engine and hence, it is uses e.g. Azure Synapse or Azure HDInsight for data transformation

Databricks
- Uses Azure's Databricks clusters, which can be configured to match your workload
- Optimised for parallel processing of large datasets and real-time data processing

#### When to Use Which?
Use ADF when you need: 
- Orchestrate and automate data movement
- A simple developing workflow
- Only ETL and minimal data analysis on the data

Use Databricks when you need:
- A unified platform for different data-roles
- Complex data-transformations and analytics on large-scale data
- Live streaming
- The flexibility to fine-tune the code and optimise performance
- Interactive collaboration with developers based on Git
