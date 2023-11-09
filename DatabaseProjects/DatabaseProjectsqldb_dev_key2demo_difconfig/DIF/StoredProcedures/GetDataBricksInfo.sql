





CREATE  PROCEDURE [DIF].[GetDataBricksInfo]
					( 
						@SourceRowCount bigint
					)

AS

/*

SP Name:  [DIF].[GetDataBricksInfo]
Purpose:  Used to get the Data Bricks Parameters information.
Parameters:
     @SourceRowCount - Source table row count

Test harnass:

select * from [config].IngestionConfig

EXEC [DIF].[GetDataBricksInfo]
	@SourceRowCount = 5000000

*/

BEGIN

 	declare @DataBricksWorkSpaceURL nvarchar(2000)
			,@DataBricksPoolID nvarchar(500)
			,@DataBricksMaxNodes varchar(5) = 1



			/*****************************************************************/
			--TEMP ONLY:  TO DO:  REMOVE THIS BLOCK AFTER [config].[IngestionConfig] is configured for demo environment
			/*****************************************************************/


			select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'Key2DemoDatabricksBasic'
			
			select @DataBricksWorkSpaceURL as DataBricksWorkSpaceURL, @DataBricksPoolID as DataBricksPoolID, @DataBricksMaxNodes as DataBricksMaxNodes

			RETURN;

			/*****************************************************************/

			if @SourceRowCount >= 50000
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L30_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L30_PoolID'
				set @DataBricksMaxNodes = 7
				end	
	
			if @SourceRowCount >= 1000000000 and @SourceRowCount < 5000000000  
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L32_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L32_PoolID'
				set @DataBricksMaxNodes = 5
				end

			if @SourceRowCount >= 100000000 and @SourceRowCount < 1000000000  
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L32_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L32_PoolID'
				set @DataBricksMaxNodes = 3
				end

			if @SourceRowCount >= 10000000 and @SourceRowCount < 100000000  
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L32_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L32_PoolID'
				set @DataBricksMaxNodes = 1
				end	
	
			if @SourceRowCount >= 5000000 and @SourceRowCount < 10000000 
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L10_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L10_PoolID'
				set @DataBricksMaxNodes = 3 
				end
			if @SourceRowCount >= 1000000 and @SourceRowCount < 5000000  
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L10_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L10_PoolID'
				set @DataBricksMaxNodes = 2 
				end
			if @SourceRowCount >= 250000 and @SourceRowCount < 1000000  
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L10_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L10_PoolID'
				set @DataBricksMaxNodes = 1 
				end	
	
			if @SourceRowCount < 250000  
				begin
		
				select @DataBricksWorkSpaceURL = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L11_URL'
				select @DataBricksPoolID = IngestionConfigValue from [config].[IngestionConfig] where IngestionConfigName = 'DB_ELT_Pool_L11_PoolID'
				set @DataBricksMaxNodes = 1 
				end

			select @DataBricksWorkSpaceURL as DataBricksWorkSpaceURL, @DataBricksPoolID as DataBricksPoolID, @DataBricksMaxNodes as DataBricksMaxNodes

END

GO

