
USE [sqldb_dev_key2demo_difconfig];
GO




----Add SOURCE Dataset EIARef_PrimeMover_Annual-------
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'landingzone'
	,@DatasetClass = 'User Created File'
	,@StorageType = 'Delimited Text File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'EIARef_PrimeMover_Annual'
	,@DatasetName = 'EIARef_PrimeMover_Annual'
	,@DatasetDescription = 'EIARef_PrimeMover_Annual'
	,@DatasetPath = 'eiaref'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK



----Add SOURCE DelimitedFile EIARef_PrimeMover_Annual----
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
	[DelimitedFileNamePattern] = N'*EIARef_PrimeMover_Annual*.csv',
	[DelimitedFileIsHeaderRowOverride] = 0;




----Add SOURCE Attributes for *EIARef_PrimeMover_Annual*----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'PrimeMoverID'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'PrimeMoverDescription'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK

GO





/*********************************************************************************/
--------------------  DESTINATION  --MUST BE LOWERCASE!!!!
/*********************************************************************************/

--SELECT * FROM [DIF].[DatasetDetail] ORDER BY 1 DESC



----Add DESTINATION Dataset eiaref_primemover_annual---- (in bronzezone)
DECLARE @DK INT

EXEC [DIF].[AddDataset]
	@SystemName = 'stkey2demodeveastus001'
	,@RepositoryName = 'bronzezone'  
	,@DatasetClass = 'Reference Table'
	,@StorageType = 'Parquet File'
	,@PartitionType = 'None'
	,@DatasetNameSpace = 'eiaref_primemover_annual'
	,@DatasetName = 'eiaref_primemover_annual'
	,@DatasetDescription = 'eiaref_primemover_annual'
	,@DatasetPath = 'eia/eiaref_primemover_annual'
	,@DatasetExternalVersionID = NULL
	,@DatasetIsCreated = 1
	,@DatasetIsEnabled = 1
	,@DatasetKey = @DK OUTPUT

SELECT @DK


UPDATE D
SET LogicalDatabaseName = 'eia_bronze'
FROM [metadata].[Dataset] D
WHERE DatasetKey = @DK;


----Add DESTINATION Attributes for eiaref_primemover_annual----  
DECLARE @AK INT;


EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'PrimeMoverID'    ,@AttributeSequenceNumber = '1'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 0    ,@AttributeIsPrimaryKey = 1    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK
EXEC [DIF].[AddAttribute]    @DatasetKey = @DK    ,@DataType = 'varchar'    ,@AttributeName = 'PrimeMoverDescription'    ,@AttributeSequenceNumber = '2'    ,@AttributeMaxLength = 255    ,@AttributePrecision = NULL    ,@AttributeScale = NULL    ,@AttributeIsNullable = 1    ,@AttributeIsPrimaryKey = 0    ,@AttributeIsUnique = 0    ,@AttributeIsForeignKey = 0    ,@AttributeIsWaterMark = 0    ,@AttributePartitionKeyOrder = NULL     ,@AttributeDistributionKeyOrder = NULL    ,@AttributeIsEnabled = 1    ,@AttributeKey = @AK OUTPUT     SELECT @AK


GO




