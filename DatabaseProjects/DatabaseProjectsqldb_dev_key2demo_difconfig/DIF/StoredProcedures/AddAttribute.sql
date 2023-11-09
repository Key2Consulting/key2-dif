





CREATE     PROCEDURE [DIF].[AddAttribute]
	(
	 @DatasetKey SMALLINT
	,@DataType VARCHAR(50)
	,@AttributeName VARCHAR(255)
	,@AttributeSequenceNumber SMALLINT
	,@AttributeMaxLength SMALLINT
	,@AttributePrecision SMALLINT
	,@AttributeScale SMALLINT
	,@AttributeIsNullable BIT = 1
	,@AttributeIsPrimaryKey BIT = 0
	,@AttributeIsUnique BIT = 0
	,@AttributeIsForeignKey BIT = 0
	,@AttributeIsWaterMark BIT = 0
	,@AttributePartitionKeyOrder TINYINT = 0
	,@AttributeDistributionKeyOrder TINYINT = 0
	,@AttributeIsEnabled BIT = 1
	,@AttributeKey INT OUTPUT
	)
AS

/*

SP Name:  [DIF].[Attribute]
Purpose:  Used to add a new DIF Attribute
Parameters:
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

DECLARE @AK INT

EXEC [DIF].[AddAttribute]
	@DatasetKey = 48
	,@DataType = 'int'
	,@AttributeName = 'TestColumn'
	,@AttributeSequenceNumber = 1
	,@AttributeMaxLength = null
	,@AttributePrecision = null
	,@AttributeScale = null
	,@AttributeIsNullable = 0 
	,@AttributeIsPrimaryKey = 1 
	,@AttributeIsUnique = 1
	,@AttributeIsForeignKey = 0
	,@AttributeIsWaterMark = 1
	,@AttributePartitionKeyOrder = null 
	,@AttributeDistributionKeyOrder = null
	,@AttributeIsEnabled = 1
	,@AttributeKey = @AK OUTPUT

SELECT @AK

*/

BEGIN

DECLARE
	@AttributeCheckKey SMALLINT
	,@DataTypeKey SMALLINT;

BEGIN TRY

/*************************************************************************************************
Check to see if the required parameters are populated
*************************************************************************************************/
IF (@DataType IS NULL OR @DatasetKey IS NULL OR @AttributeName IS NULL OR @AttributeSequenceNumber IS NULL )
	THROW 50101, 'The @DatasetKey, @AttributeName and @AttributeSequenceNumber parameters must be specified.', 1;

/*************************************************************************************************
Check for the @DataTypeKey value
*************************************************************************************************/
SELECT
	@DataTypeKey = DataTypeKey
FROM
	reference.DataType
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
Check to verify that the Attribute provided doesn't already exist
*************************************************************************************************/
SELECT
	@AttributeCheckKey = AttributeKey
FROM
	metadata.Attribute
WHERE
	DatasetKey = @DatasetKey
	AND AttributeName = @AttributeName

IF @AttributeCheckKey IS NOT NULL
	THROW 50102, 'The provided Attribute values already exists in the [metadata].Attribute table for this Dataset.  Please use the DIF.UpdateAttribute store procedure to update any values in that table.', 1;


/*************************************************************************************************
Add new [metadata].Attribute record
*************************************************************************************************/
	BEGIN TRAN;

		INSERT INTO [metadata].[Attribute]
			(
			 [DataTypeKey]
			 , [DatasetKey]
			 , [AttributeName]
			 , [AttributeSequenceNumber]
			 , [AttributeMaxLength]
			 , [AttributePrecision]
			 , [AttributeScale]
			 , [AttributeIsNullable]
			 , [AttributeIsPrimaryKey]
			 , [AttributeIsUnique]
			 , [AttributeIsForeignKey]
			 , [AttributeIsWaterMark]
			 , [AttributePartitionKeyOrder]
			 , [AttributeDistributionKeyOrder]
			 , [AttributeIsEnabled]
			 , [CreatedBy]
			 , [CreatedDateTime]
			 , [ModifiedBy]
			 , [ModifiedDateTime]
			)
		VALUES
			(
			@DataTypeKey
			,@DatasetKey
			,@AttributeName
			,@AttributeSequenceNumber
			,@AttributeMaxLength
			,@AttributePrecision
			,@AttributeScale
			,@AttributeIsNullable
			,@AttributeIsPrimaryKey
			,@AttributeIsUnique
			,@AttributeIsForeignKey
			,@AttributeIsWaterMark
			,@AttributePartitionKeyOrder
			,@AttributeDistributionKeyOrder
			,@AttributeIsEnabled
			,suser_sname()
			,getutcdate()
			,suser_sname()
			,getutcdate()
			);

		SET @AttributeKey = SCOPE_IDENTITY();

	COMMIT TRAN;

	
END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRAN;

THROW;

END CATCH

END

GO

