
USE [sqldb_dev_key2demo_difconfig];
GO




----Add SOURCE/DESTINATION System: stkey2demodeveastus001----
DECLARE @SK SMALLINT

EXEC [DIF].[AddSystem]
	@SystemType = 'Azure Storage Account'
	,@EnvironmentType = 'Testing'
	,@SystemName = 'stkey2demodeveastus001'
	,@SystemDescription = 'data lake gen2 storage account'
	,@SystemProgram = 'Key2 Demo'
	,@SystemFQDN = 'https://stkey2demodeveastus001.dfs.core.windows.net/'
--	,@SystemUserName
	,@SystemSecretName = 'key2demo-adf-adls-secret'
	,@SystemIsEnabled = 1
	,@SystemKey = @SK OUTPUT

SELECT @SK
GO

----Add SOURCE Repository: landingzone----
DECLARE @RK SMALLINT 

EXEC [DIF].[AddRepository]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryType = 'Azure Data Lake Zone'
	,@RepositoryName = 'landingzone'
	,@RepositoryDescription = 'Key2 Demo datalake landingzone'
	,@RepositoryPathPattern = NULL
	,@RepositoryIsEnabled = 1
	,@RepositoryKey = @RK OUTPUT

SELECT @RK
GO



----Add DESTINATION Repository: bronzezone----
DECLARE @RK SMALLINT 

EXEC [DIF].[AddRepository]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryType = 'Azure Data Lake Zone'
	,@RepositoryName = 'bronzezone'
	,@RepositoryDescription = 'Key2 Demo datalake bronzezone'
	,@RepositoryPathPattern = NULL
	,@RepositoryIsEnabled = 1
	,@RepositoryKey = @RK OUTPUT

SELECT @RK


----Add DESTINATION Repository: silverzone----
--DECLARE @RK SMALLINT 

EXEC [DIF].[AddRepository]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryType = 'Azure Data Lake Zone'
	,@RepositoryName = 'silverzone'
	,@RepositoryDescription = 'Key2 Demo datalake silverzone'
	,@RepositoryPathPattern = NULL
	,@RepositoryIsEnabled = 1
	,@RepositoryKey = @RK OUTPUT

SELECT @RK





--SELECT * FROM [DIF].[DatasetDetail] ORDER BY 1 DESC



----Add SOURCE Dataset EIA861_Sales_Ult_Cust_Annual----
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'landingzone'
	,@DatasetClass = 'User Created File'
	,@StorageType = 'Delimited Text File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'EIA861_Sales_Ult_Cust_Annual'
	,@DatasetName = 'EIA861_Sales_Ult_Cust_Annual'
	,@DatasetDescription = 'EIA861_Sales_Ult_Cust_Annual'
	,@DatasetPath = 'eia861'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK



----Add SOURCE DelimitedFile EIA861_Sales_Ult_Cust_Annual----
INSERT INTO  [metadata].[DelimitedFile] 
(

[DatasetKey], 
[DelimitedFileCompressionType],
[DelimitedFileCompressionLevel],
[DelimitedFileColumnDelimiter], 
[DelimitedFileRowDelimiter], 
[DelimitedFileEncoding], 
[DelimitedFileEscapeCharacter], 
[DelimitedFileQuoteCharacter], 
[DelimitedFileFirstRowAsHeader], 
[DelimitedFileNULLValue], 
[DelimitedFileNamePattern],
[DelimitedFileIsHeaderRowOverride]
) 
SELECT
	[DatasetKey] = @DK, 
	[DelimitedFileCompressionType] = N'None', 
	[DelimitedFileCompressionLevel] = NULL,
	[DelimitedFileColumnDelimiter] = '|',
	[DelimitedFileRowDelimiter] = CHAR(13) + CHAR(10), --carriage return line feed
	[DelimitedFileEncoding] = N'UTF-8', 
	[DelimitedFileEscapeCharacter] = N'\', 
	[DelimitedFileQuoteCharacter] = NULL, 
	[DelimitedFileFirstRowAsHeader] = 1, 
	[DelimitedFileNULLValue] = 'null',    /*used to indicate the string representation of a SQL null value in the source text file, default is empty string in ADF, we set to 'null' here so that empty strings are blank in target parquest file.  Need this for downstream merge to silver delta table*/ 
	[DelimitedFileNamePattern] = N'*EIA861_Sales_Ult_Cust_Annual*.csv',
	[DelimitedFileIsHeaderRowOverride] = 0;




----Add SOURCE Attributes for *eia861_sales_ult_cust*----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'DataYear'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'UtilityNumber'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'UtilityName'    ,@AttributeSequenceNumber = '3'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'Part'    ,@AttributeSequenceNumber = '4'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'SERVICE_TYPE'    ,@AttributeSequenceNumber = '5'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'DataType'    ,@AttributeSequenceNumber = '6'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'State'    ,@AttributeSequenceNumber = '7'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'Ownership'    ,@AttributeSequenceNumber = '8'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'BA_CODE'    ,@AttributeSequenceNumber = '9'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'ResidentialRevenues'    ,@AttributeSequenceNumber = '10'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'ResidentialSales'    ,@AttributeSequenceNumber = '11'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'ResidentialCustomers'    ,@AttributeSequenceNumber = '12'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'CommercialRevenues'    ,@AttributeSequenceNumber = '13'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'CommercialSales'    ,@AttributeSequenceNumber = '14'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'CommercialCustomers'    ,@AttributeSequenceNumber = '15'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'IndustrialRevenues'    ,@AttributeSequenceNumber = '16'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'IndustrialSales'    ,@AttributeSequenceNumber = '17'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'IndustrialCustomers'    ,@AttributeSequenceNumber = '18'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TransportationRevenues'    ,@AttributeSequenceNumber = '19'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TransportationSales'    ,@AttributeSequenceNumber = '20'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'TransportationCustomers'    ,@AttributeSequenceNumber = '21'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TotalRevenues'    ,@AttributeSequenceNumber = '22'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TotalSales'    ,@AttributeSequenceNumber = '23'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'TotalCustomers'    ,@AttributeSequenceNumber = '24'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK


GO





/*********************************************************************************/
--------------------  DESTINATION  --MUST BE LOWERCASE!!!!
/*********************************************************************************/

--SELECT * FROM [DIF].[DatasetDetail] ORDER BY 1 DESC



----Add DESTINATION Dataset eia861_sales_ult_cust_annual---- (in bronzezone)
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'bronzezone'  
	,@DatasetClass = 'Reference Table'
	,@StorageType = 'Parquet File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'eia861_sales_ult_cust_annual'
	,@DatasetName = 'eia861_sales_ult_cust_annual'
	,@DatasetDescription = 'eia861_sales_ult_cust_annual'
	,@DatasetPath = 'eia/eia861_sales_ult_cust_annual'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK


UPDATE D
SET LogicalDatabaseName = 'eia_bronze'
FROM [metadata].[Dataset] D
WHERE DatasetKey = @DK;


----Add DESTINATION Attributes for eia861_sales_ult_cust----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'DataYear'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'UtilityNumber'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'UtilityName'    ,@AttributeSequenceNumber = '3'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'Part'    ,@AttributeSequenceNumber = '4'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'SERVICE_TYPE'    ,@AttributeSequenceNumber = '5'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'DataType'    ,@AttributeSequenceNumber = '6'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'State'    ,@AttributeSequenceNumber = '7'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'Ownership'    ,@AttributeSequenceNumber = '8'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'BA_CODE'    ,@AttributeSequenceNumber = '9'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'ResidentialRevenues'    ,@AttributeSequenceNumber = '10'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'ResidentialSales'    ,@AttributeSequenceNumber = '11'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'ResidentialCustomers'    ,@AttributeSequenceNumber = '12'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'CommercialRevenues'    ,@AttributeSequenceNumber = '13'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'CommercialSales'    ,@AttributeSequenceNumber = '14'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'CommercialCustomers'    ,@AttributeSequenceNumber = '15'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'IndustrialRevenues'    ,@AttributeSequenceNumber = '16'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'IndustrialSales'    ,@AttributeSequenceNumber = '17'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'IndustrialCustomers'    ,@AttributeSequenceNumber = '18'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TransportationRevenues'    ,@AttributeSequenceNumber = '19'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TransportationSales'    ,@AttributeSequenceNumber = '20'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'TransportationCustomers'    ,@AttributeSequenceNumber = '21'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TotalRevenues'    ,@AttributeSequenceNumber = '22'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'TotalSales'    ,@AttributeSequenceNumber = '23'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'TotalCustomers'    ,@AttributeSequenceNumber = '24'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK


GO






----Add Project----	
DECLARE @PK INT

EXEC [DIF].[AddProject]
	@ProjectType = 'Key2Demo'
	,@ProjectName = 'EIA-Electricity Generation'   
	,@ProjectKey = @PK OUTPUT

SELECT @PK 


INSERT INTO [config].[IngestionConfig]
    (
	[ProjectKey]
    ,[IngestionConfigType]
    ,[IngestionConfigName]
    ,[IngestionConfigValue]
    )
SELECT
	[ProjectKey] = @PK
    ,[IngestionConfigType] = 'DataBricksWorkSpaceURL'
    ,[IngestionConfigName] = 'Key2DemoDatabricksBasic'
    ,[IngestionConfigValue]	= 'https://adb-6999517856698859.19.azuredatabricks.net/'


GO


	
----Add Pipeline(s)----

----Add Pipeline: PL_DIF_DelimitedFile_GroupOrder
DECLARE @PK INT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'EIA-Electricity Generation'
	,@PipelineShortName = 'PL_DIF_DelimitedFile_GroupOrder'
	,@PipelineFullName = 'PL_DIF_DelimitedFile_GroupOrder'
	,@PipelineFolder = 'DIF DelimitedFile'
	,@PipelineDescription = 'PL_DIF_DelimitedFile_GroupOrder'
	,@PipelineKey = @PK OUTPUT

SELECT @PK  
GO

----Add Pipeline: PL_DIF_DelimitedFile_TaskLoop
DECLARE @PK INT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'EIA-Electricity Generation'
	,@PipelineShortName = 'PL_DIF_DelimitedFile_TaskLoop'
	,@PipelineFullName = 'PL_DIF_DelimitedFile_TaskLoop'
	,@PipelineFolder = 'DIF DelimitedFile'
	,@PipelineDescription = 'PL_DIF_DelimitedFile_TaskLoop'
	,@PipelineKey = @PK OUTPUT

SELECT @PK  
GO

----Add Pipeline: PL_DIF_DelimitedFile_ToParquet
DECLARE @PK INT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'EIA-Electricity Generation'
	,@PipelineShortName = 'PL_DIF_DelimitedFile_ToParquet'
	,@PipelineFullName = 'PL_DIF_DelimitedFile_ToParquet'
	,@PipelineFolder = 'DIF DelimitedFile'
	,@PipelineDescription = 'PL_DIF_DelimitedFile_ToParquet'
	,@PipelineKey = @PK OUTPUT

SELECT @PK  
GO

----Add Pipeline: PL_DIF_DelimitedFile_RawToRefined
DECLARE @PK INT

EXEC [DIF].[AddPipeline]
	@ProjectName = 'EIA-Electricity Generation'
	,@PipelineShortName = 'PL_DIF_DelimitedFile_RawToRefined'
	,@PipelineFullName = 'PL_DIF_DelimitedFile_RawToRefined'
	,@PipelineFolder = 'DIF DelimitedFile'
	,@PipelineDescription = 'PL_DIF_DelimitedFile_RawToRefined'
	,@PipelineKey = @PK OUTPUT

SELECT @PK  
GO


----Add AddDIGroup----
DECLARE @DK INT

EXEC [DIF].[AddDIGroup]
	@DIGroupName = 'EIA-ElecGen-DF to Bronze + Silver Zones'
	,@ProjectName = 'EIA-Electricity Generation'
	,@DIGroupIsEnabled = 1
	,@DIGroupKey = @DK OUTPUT

SELECT @DK

GO



