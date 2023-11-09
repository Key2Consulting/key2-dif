
USE [sqldb_dev_key2demo_difconfig];
GO




----Add SOURCE Dataset EIARef_FuelType_Annual-------
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'landingzone'
	,@DatasetClass = 'User Created File'
	,@StorageType = 'Delimited Text File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'EIARef_FuelType_Annual'
	,@DatasetName = 'EIARef_FuelType_Annual'
	,@DatasetDescription = 'EIARef_FuelType_Annual'
	,@DatasetPath = 'eiaref'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK



----Add SOURCE DelimitedFile EIARef_FuelType_Annual----
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
	[DelimitedFileNamePattern] = N'*EIARef_FuelType_Annual*.csv',
	[DelimitedFileIsHeaderRowOverride] = 0;




----Add SOURCE Attributes for *EIARef_FuelType_Annual*----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'FuelTypeID'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'FuelClass'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'FuelSubClass'    ,@AttributeSequenceNumber = '3'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'PhysicalUnitLabel'    ,@AttributeSequenceNumber = '4'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'HeatContentMMBtuLower'    ,@AttributeSequenceNumber = '5'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'HeatContentMMBtuUpper'    ,@AttributeSequenceNumber = '6'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'EnergySourceDescription'    ,@AttributeSequenceNumber = '7'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK


GO





/*********************************************************************************/
--------------------  DESTINATION  --MUST BE LOWERCASE!!!!
/*********************************************************************************/

--SELECT * FROM [DIF].[DatasetDetail] ORDER BY 1 DESC



----Add DESTINATION Dataset eiaref_fueltype_annual---- (in bronzezone)
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'bronzezone'  
	,@DatasetClass = 'Reference Table'
	,@StorageType = 'Parquet File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'eiaref_fueltype_annual'
	,@DatasetName = 'eiaref_fueltype_annual'
	,@DatasetDescription = 'eiaref_fueltype_annual'
	,@DatasetPath = 'eia/eiaref_fueltype_annual'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK


UPDATE D
SET LogicalDatabaseName = 'eia_bronze'
FROM [metadata].[Dataset] D
WHERE DatasetKey = @DK;


----Add DESTINATION Attributes for eiaref_fueltype_annual----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'FuelTypeID'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'FuelClass'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'FuelSubClass'    ,@AttributeSequenceNumber = '3'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'PhysicalUnitLabel'    ,@AttributeSequenceNumber = '4'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'HeatContentMMBtuLower'    ,@AttributeSequenceNumber = '5'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'float'    ,@AttributeName = 'HeatContentMMBtuUpper'    ,@AttributeSequenceNumber = '6'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'EnergySourceDescription'    ,@AttributeSequenceNumber = '7'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK


GO




