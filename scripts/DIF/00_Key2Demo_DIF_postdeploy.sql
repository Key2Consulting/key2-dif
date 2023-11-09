USE [sqldb_dev_key2demo_difconfig]
GO


/*
							
----------------------------------------------------------------------------------------
Run this script immediately after deploying the DIF dacpac to Azure.	

Script will populate tables in reference schema.				
--------------------------------------------------------------------------------------
*/
SET IDENTITY_INSERT [reference].[PartitionType] ON 
GO
INSERT [reference].[PartitionType] ([PartitionTypeKey], [PartitionType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'None', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PartitionType] ([PartitionTypeKey], [PartitionType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'Sta3n', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PartitionType] ([PartitionTypeKey], [PartitionType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'Year', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PartitionType] ([PartitionTypeKey], [PartitionType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'Quarter', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PartitionType] ([PartitionTypeKey], [PartitionType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'Month', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[PartitionType] OFF
GO

SET IDENTITY_INSERT [reference].[DatasetClass] ON 
GO
INSERT [reference].[DatasetClass] ([DatasetClassKey], [DatasetClass], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'Dimension', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DatasetClass] ([DatasetClassKey], [DatasetClass], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'Fact Table', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DatasetClass] ([DatasetClassKey], [DatasetClass], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'Log Table', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DatasetClass] ([DatasetClassKey], [DatasetClass], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'Reference Table', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DatasetClass] ([DatasetClassKey], [DatasetClass], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'Reference View', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DatasetClass] ([DatasetClassKey], [DatasetClass], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (6, N'User Created File', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[DatasetClass] OFF
GO

SET IDENTITY_INSERT [reference].[DataType] ON 
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'char', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'varchar', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'nchar', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'nvarchar', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'text', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (6, N'ntext', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (7, N'binary', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (8, N'varbinary', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (9, N'image', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (10, N'uniqueidentifier', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (11, N'tinyint', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (12, N'smallint', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (13, N'int', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (14, N'bigint', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (15, N'date', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (16, N'time', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (17, N'smalldatetime', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (18, N'datetime', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (19, N'datetime2', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (20, N'datetimeoffset', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (21, N'bit', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (22, N'decimal', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (23, N'numeric', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (24, N'smallmoney', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (25, N'money', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (26, N'float', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[DataType] ([DataTypeKey], [DataType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (27, N'real', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[DataType] OFF
GO

SET IDENTITY_INSERT [reference].[EnvironmentType] ON 
GO
INSERT [reference].[EnvironmentType] ([EnvironmentTypeKey], [EnvironmentType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'Production', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[EnvironmentType] ([EnvironmentTypeKey], [EnvironmentType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'Pre-Production', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[EnvironmentType] ([EnvironmentTypeKey], [EnvironmentType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'Staging', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[EnvironmentType] ([EnvironmentTypeKey], [EnvironmentType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'Testing', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[EnvironmentType] ([EnvironmentTypeKey], [EnvironmentType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'Development', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[EnvironmentType] OFF
GO

/********CONTINUE FROM HERE, ROW 3 MUST BE INSERTED BEFORE 2*********/
SET IDENTITY_INSERT [reference].[LoadType] ON 
GO
INSERT [reference].[LoadType] ([LoadTypeKey], [SubsequentLoadTypeKey], [LoadType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, NULL, N'Full Only', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO

INSERT [reference].[LoadType] ([LoadTypeKey], [SubsequentLoadTypeKey], [LoadType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, NULL, N'Incremental', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO

INSERT [reference].[LoadType] ([LoadTypeKey], [SubsequentLoadTypeKey], [LoadType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, 3, N'Full then Incremental', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2))
GO

SET IDENTITY_INSERT [reference].[LoadType] OFF
GO

SET IDENTITY_INSERT [reference].[PipelineResultName] ON 
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'RowsRead', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'RowsCopied', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'CopyDuration', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'Throughput', 0, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'HighWaterMark', 0, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (6, N'ETLBatchID', 0, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (7, N'SinkPath', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (8, N'SourceAuditQueryValue', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (9, N'SinkFileName', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (10, N'LoadType', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (11, N'SourceQuery', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO

INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (12, N'ExecutionStatus', 0, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (13, N'RowsInserted', 0, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (14, N'RowsUpdated', 0, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (15, N'RowsDeleted', 0, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (16, N'SinkPath_COMBINED', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineResultName] ([PipelineResultNameKey], [PipelineResultName], [PipelineResultNameIsStandard], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (17, N'SinkFileName_COMBINED', 1, N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO

SET IDENTITY_INSERT [reference].[PipelineResultName] OFF
GO

SET IDENTITY_INSERT [reference].[PipelineStatus] ON 
GO
INSERT [reference].[PipelineStatus] ([PipelineStatusKey], [PipelineStatus], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'InProgress', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineStatus] ([PipelineStatusKey], [PipelineStatus], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'Succeeded', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineStatus] ([PipelineStatusKey], [PipelineStatus], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'Failed', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineStatus] ([PipelineStatusKey], [PipelineStatus], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'Canceled', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineStatus] ([PipelineStatusKey], [PipelineStatus], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'Canceling', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[PipelineStatus] ([PipelineStatusKey], [PipelineStatus], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (6, N'Queued', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[PipelineStatus] OFF
GO

SET IDENTITY_INSERT [reference].[ProjectType] ON 
GO
INSERT [reference].[ProjectType] ([ProjectTypeKey], [ProjectType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'Key2Demo', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[ProjectType] OFF
GO

SET IDENTITY_INSERT [reference].[RepositoryType] ON 
GO
INSERT [reference].[RepositoryType] ([RepositoryTypeKey], [RepositoryType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'Azure Data Lake Zone', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[RepositoryType] ([RepositoryTypeKey], [RepositoryType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'Azure DB Database', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[RepositoryType] ([RepositoryTypeKey], [RepositoryType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'SQL Server Database', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[RepositoryType] ([RepositoryTypeKey], [RepositoryType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'Oracle Database', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[RepositoryType] ([RepositoryTypeKey], [RepositoryType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'Windows Fileshare', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[RepositoryType] OFF
GO

SET IDENTITY_INSERT [reference].[StorageType] ON 
GO
INSERT [reference].[StorageType] ([StorageTypeKey], [StorageType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'Relational Table', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[StorageType] ([StorageTypeKey], [StorageType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'Relational View', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[StorageType] ([StorageTypeKey], [StorageType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'CSV File', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[StorageType] ([StorageTypeKey], [StorageType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'Parquet File', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[StorageType] ([StorageTypeKey], [StorageType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (5, N'Delimited Text File', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[StorageType] ([StorageTypeKey], [StorageType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (6, N'Databricks Delta Table', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[StorageType] ([StorageTypeKey], [StorageType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (7, N'Excel File', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[StorageType] OFF
GO

SET IDENTITY_INSERT [reference].[SystemType] ON 
GO
INSERT [reference].[SystemType] ([SystemTypeKey], [SystemType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (1, N'RDBMS', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[SystemType] ([SystemTypeKey], [SystemType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (2, N'Azure Storage Account', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[SystemType] ([SystemTypeKey], [SystemType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (3, N'File Server', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
INSERT [reference].[SystemType] ([SystemTypeKey], [SystemType], [CreatedBy], [CreatedDateTime], [ModifiedBy], [ModifiedDateTime]) VALUES (4, N'FTP Server', N'DESKTOP-ESIDTSH\Key2', CAST(GETDATE() AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [reference].[SystemType] OFF
GO
