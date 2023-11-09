# Key2 Azure Demo

## This demo is for a data platform residing in Azure

### Description
Key2 created this project to showcase a modern data platform that is based on data sourced from the **Energy Information Administration (EIA)**.  Here is a synopsis of what the EIA does straight from their [website](https://www.eia.gov/about/mission_overview.php#:~:text=EIA%20collects%2C%20analyzes%2C%20and%20disseminates,the%20economy%20and%20the%20environment.).

What does the Energy Information Administration do?

EIA collects, analyzes, and disseminates independent and impartial energy information to promote sound policymaking, efficient markets, and public understanding of energy and its interaction with the economy and the environment.

The EIA data platform is a lakehouse architecture that highlights several important services from Azure:
- Azure Data Lake Storage (ADLS) Gen2
- Azure Data Factory (ADF)
- Databricks
- Azure SQL

The data is extracted from EIA using their API and we focused on electricity generation.  Configurable ADF pipelines are in place to pull that generation data in an incremental fashion.  Delta Live Tables (DLT) are in place to handle streaming the incoming data and apply that via change data capture (CDC).  Finally, Databricks notebooks are executed to take the versioned data and shapes that into a dimensional model.  The model is then served via Databricks to Power BI where we have a fully functional dashboard to further analyze the data.

### Instructions for using
At the moment, we're asking that folks download the code from this repository and deploy it to your own resource group.  See the links below for documentation to set up your resource group.  This will allow you to use the code in a sandbox type environment without stepping on the live demo.  At some point, we will open it up to contributions and create separate Dev and Prod resource groups.

## Additional information and documentation to help you get started

**Key2 Data Ingestion Framework**

- [Overview](https://github.com/Key2Consulting/key2-demo-eia/blob/main/documentation/Key2%20Data%20Ingestion%20Framework%20Overview.docx)
- [Database Configuration Guide](https://github.com/Key2Consulting/key2-demo-eia/blob/main/documentation/Key2%20Data%20Ingestion%20Framework%20-%20Configuration%20Database%20Guide.docx)
- [Data Factory Pipeline Overview](https://github.com/Key2Consulting/key2-demo-eia/blob/main/documentation/Key2%20Data%20Ingestion%20Framework%20-%20ADF%20Pipeline%20Overview.docx)
- [EIA Resource Provisioning](https://github.com/Key2Consulting/key2-demo-eia/blob/main/documentation/Key2%20Azure%20Resource%20Provisioning%20-%20Data%20Integration.docx)


## EIA Lakehouse Model
![Energy ERD - EIA-Draft drawio](https://github.com/Key2Consulting/key2-demo-eia/assets/6819627/605b1f8d-5fda-4eb0-9461-71574d5f45dc)

## EIA Medallion Architecture
![Medallion Architecture](https://github.com/Key2Consulting/key2-demo-eia/assets/6819627/edf0e635-0be0-4dc3-a14b-927135b0b83c)


