
CREATE     PROCEDURE [DIF].[UpdateAttribute]
	(
	 @AttributeKey INT
	,@DatasetKey SMALLINT
	,@DataType VARCHAR(50)
	,@AttributeName VARCHAR(255)
	,@AttributeSequenceNumber SMALLINT
	,@AttributeMaxLength SMALLINT = null
	,@AttributePrecision SMALLINT = null
	,@AttributeScale SMALLINT = null
	,@AttributeIsNullable BIT = 1
	,@AttributeIsPrimaryKey BIT = 0
	,@AttributeIsUnique BIT = 0
	,@AttributeIsForeignKey BIT = 0
	,@AttributeIsWaterMark BIT = 0
	,@AttributePartitionKeyOrder TINYINT = 0
	,@AttributeDistributionKeyOrder TINYINT = 0
	,@AttributeIsEnabled BIT = 1
	)
AS

/*

SP Name:  [DIF].[Attribute]
Purpose:  Used to update an existing DIF Attribute
Parameters:
	@AttributeKey - key value for the given Attribute record to be updated
	@DatasetKey - key value for the dataset
	@DataType - identifies the associated DataType.  Examples varchar, int, datetime2
	@AttributeName - Attribute name in the associated dataset
	@AttributeSequenceNumber - Attribute order in the corresponding dataset
	@AttributeMaxLength - maximum value for a given data type.  Example A varchar(50) attribute would have a max length of 50
	@AttributePrecision - Precision is the number of digits in the given data type.  Example decimal(12,2) the precision would be 12
	@AttributeScale - Scale is the number of digits to the right of the decimal point.  Example decimal (12,2) the scale would be 2
	@AttributeIsNullable - identifies if the Attribute is nullable
	@AttributeIsPrimaryKey - identifies if the Attribute is part of the PK in the dataset
	@AttributeIsUnique - identifies if the Attribute is part of the unique identifier of the dataset
	@AttributeIsForeignKey - identifies if the Attribute is part a foreign key reference in the dataset
	@AttributeIsWaterMark - identifies if the Attribute is used to track high watermark values
	@AttributePartitionKeyOrder - identifies if the Attribute is used to partition the dataset
	@AttributeDistributionKeyOrder - identifies if the Attribute is part of the distribution key
	@AttributeIsEnabled - Determines if an Attribute is active or not

Test harnass:

SELECT * FROM [metadata].[Dataset]
SELECT * FROM [reference].[DataType]
SELECT * FROM [metadata].[Attribute]

EXEC [DIF].[UpdateAttribute]
	 @AttributeKey = 146
	,@DatasetKey = 48
	,@DataType = 'varchar'
	,@AttributeName = 'TestCol'
	,@AttributeSequenceNumber = 1
	,@AttributeMaxLength = 50
	,@AttributePrecision = 0
	,@AttributeScale = 0
	,@AttributeIsNullable = 0 
	,@AttributeIsPrimaryKey = 0
	,@AttributeIsUnique = 0
	,@AttributeIsForeignKey = 1
	,@AttributeIsWaterMark = 0
	,@AttributePartitionKeyOrder = 0 
	,@AttributeDistributionKeyOrder = 0
	,@AttributeIsEnabled = 1

*/

BEGIN

DECLARE
	@DataTypeKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the required parameters are populated
*************************************************************************************************/
IF (@AttributeKey IS NULL OR @DataType IS NULL OR @DatasetKey IS NULL OR @AttributeName IS NULL OR @AttributeSequenceNumber IS NULL )
	THROW 50101, 'The @AttributeKey, @DatasetKey, @AttributeName and @AttributeSequenceNumber parameters must be specified.', 1;

/*************************************************************************************************
Check for the @DataTypeKey value
*************************************************************************************************/
SELECT
	@DataTypeKey = DataTypeKey
FROM
	[reference].DataType
WHERE
	DataType = @DataType

IF @DataTypeKey IS NULL
	THROW 50105, 'An unknown DataType was identified by the @DataType parameter.', 1;

/*************************************************************************************************
Check for the @DatasetKey value
*************************************************************************************************/
IF not exists(select DatasetKey from [metadata].Dataset where DatasetKey = @DatasetKey)
	THROW 50105, 'An unknown Dataset was identified by the @DatasetKey parameter.', 1;


/*************************************************************************************************
Check to verify that the DITask provided doesn't already exist
*************************************************************************************************/
IF exists(SELECT AttributeKey FROM [metadata].Attribute WHERE DatasetKey = @DatasetKey	AND AttributeName = @AttributeName and AttributeKey <> @AttributeKey)
	THROW 50102, 'The provided Attribute values already exists in the [metadata].Attribute table for the given dataset.', 1;

/*************************************************************************************************
Add new [metadata].Attribute record
*************************************************************************************************/
	BEGIN TRAN;

		Update [metadata].[Attribute]
		SET DatasetKey = @DatasetKey
			,DataTypeKey = @DataTypeKey
			,AttributeName = @AttributeName
			,AttributeSequenceNumber = @AttributeSequenceNumber
			,AttributeMaxLength = isNull(@AttributeMaxLength,AttributeMaxLength)
			,AttributePrecision = isNull(@AttributePrecision,AttributePrecision)
			,AttributeScale = isNull(@AttributeScale,AttributeScale)
			,AttributeIsNullable = @AttributeIsNullable
			,AttributeIsPrimaryKey = @AttributeIsPrimaryKey
			,AttributeIsUnique = @AttributeIsUnique
			,AttributeIsForeignKey = @AttributeIsForeignKey
			,AttributeIsWaterMark = @AttributeIsWaterMark
			,AttributePartitionKeyOrder = @AttributePartitionKeyOrder
			,AttributeDistributionKeyOrder = @AttributeDistributionKeyOrder
			,AttributeIsEnabled = @AttributeIsEnabled
			,ModifiedBy = suser_sname()
			,ModifiedDateTime = getutcdate()
		WHERE AttributeKey = @AttributeKey;

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

