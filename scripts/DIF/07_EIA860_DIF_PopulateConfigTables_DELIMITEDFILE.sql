
USE [sqldb_dev_key2demo_difconfig];
GO





----Add SOURCE Dataset EIA860_Utility_Annual-------
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'landingzone'
	,@DatasetClass = 'User Created File'
	,@StorageType = 'Delimited Text File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'EIA860_Utility_Annual'
	,@DatasetName = 'EIA860_Utility_Annual'
	,@DatasetDescription = 'EIA860_Utility_Annual'
	,@DatasetPath = 'eia860'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK



----Add SOURCE DelimitedFile EIA860_Utility_Annual----
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
	[DelimitedFileNamePattern] = N'*EIA860_Utility_Annual*.csv',
	[DelimitedFileIsHeaderRowOverride] = 0;




----Add SOURCE Attributes for *EIA860_Utility_Annual*----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'DataYear'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'UtilityID'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'UtilityName'    ,@AttributeSequenceNumber = '3'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'StreetAddress'    ,@AttributeSequenceNumber = '4'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'City'    ,@AttributeSequenceNumber = '5'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'State'    ,@AttributeSequenceNumber = '6'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'Zip'    ,@AttributeSequenceNumber = '7'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'OwnerofPlantsReportedonForm'    ,@AttributeSequenceNumber = '8'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'OperatorofPlantsReportedonForm'    ,@AttributeSequenceNumber = '9'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'AssetManagerofPlantsReportedonForm'    ,@AttributeSequenceNumber = '10'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'OtherRelationshipswithPlantsReportedonForm'    ,@AttributeSequenceNumber = '11'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'EntityType'    ,@AttributeSequenceNumber = '12'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK


GO





/*********************************************************************************/
--------------------  DESTINATION  --MUST BE LOWERCASE!!!!
/*********************************************************************************/

--SELECT * FROM [DIF].[DatasetDetail] ORDER BY 1 DESC



----Add DESTINATION Dataset eia860_utility_annual---- (in bronzezone)
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'bronzezone'  
	,@DatasetClass = 'Reference Table'
	,@StorageType = 'Parquet File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'eia860_utility_annual'
	,@DatasetName = 'eia860_utility_annual'
	,@DatasetDescription = 'eia860_utility_annual'
	,@DatasetPath = 'eia/eia860_utility_annual'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK


UPDATE D
SET LogicalDatabaseName = 'eia_bronze'
FROM [metadata].[Dataset] D
WHERE DatasetKey = @DK;


----Add DESTINATION Attributes for EIA860_Utility_Annual----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'DataYear'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'int'    ,@AttributeName = 'UtilityID'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'UtilityName'    ,@AttributeSequenceNumber = '3'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'StreetAddress'    ,@AttributeSequenceNumber = '4'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'City'    ,@AttributeSequenceNumber = '5'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'State'    ,@AttributeSequenceNumber = '6'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'Zip'    ,@AttributeSequenceNumber = '7'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'OwnerofPlantsReportedonForm'    ,@AttributeSequenceNumber = '8'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'OperatorofPlantsReportedonForm'    ,@AttributeSequenceNumber = '9'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'AssetManagerofPlantsReportedonForm'    ,@AttributeSequenceNumber = '10'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'OtherRelationshipswithPlantsReportedonForm'    ,@AttributeSequenceNumber = '11'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'EntityType'    ,@AttributeSequenceNumber = '12'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK


GO





