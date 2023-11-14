# Key2 Data Ingestion Framework (DIF)

### Description
Key2 cultivated this Data Ingestion Framework (DIF) to bring data from disparate systems into a data lake.  The data is landed into the bronze zone and then transformed and transferred into the silver and gold zones. 

The framework is used to consume data and is targeted at ingesting data using both full and incremental design patterns from SQL Server, Excel, and delimited file data sources. This framework can be extended to include data sources such as JSON and others.  The goal of the framework is to create a template pipeline and inform those pipelines via metadata.   

The DIF includes two specific components:

- Metadata and configuration information (as well as logging data) 

- Template Azure Data Factory (ADF) pipelines to ingest data into the storage account

### Instructions for using
At the moment, we're asking that folks download the code from this repository and deploy it to your own resource group.  At some point, we will open it up to contributions.

## Additional information and documentation to help you get started

**Key2 Data Ingestion Framework**

- [Overview](https://github.com/Key2Consulting/key2-demo-eia/blob/main/documentation/Key2%20Data%20Ingestion%20Framework%20Overview.docx)
- [Database Configuration Guide](https://github.com/Key2Consulting/key2-demo-eia/blob/main/documentation/Key2%20Data%20Ingestion%20Framework%20-%20Configuration%20Database%20Guide.docx)
- [Data Factory Pipeline Overview](https://github.com/Key2Consulting/key2-demo-eia/blob/main/documentation/Key2%20Data%20Ingestion%20Framework%20-%20ADF%20Pipeline%20Overview.docx)
- [DIF ERD](https://github.com/Key2Consulting/key2-dif/blob/main/documentation/Data%20Ingestion%20Framework%20-%20ERD.pdf)


