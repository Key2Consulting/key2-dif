# Databricks notebook source
# DBTITLE 1,Legend
"""
service name : 
notebook name : NB_IncrementalTableRepl_Refined_DataLake
Objective : This notebook handles the incremental load of tables to Refined Zone in Data Lake format. The source data will be traditional parquet format in the rawzone.
This is a parameter driven notebook that accepts location of files in Raw Zone, re partition the files in it and load it to the Refined Zone. 

"""

# COMMAND ----------

# DBTITLE 1,Accept Parameters & format them

############----- Get parameters from ADF pipleine calling this notebook ------------
rawMountPoint = dbutils.widgets.get("rawMountPoint");
refinedMountPoint = dbutils.widgets.get("refinedMountPoint")
rawFolder = dbutils.widgets.get("rawFolder");
refinedFolder = dbutils.widgets.get("refinedFolder")

SourceServerName = dbutils.widgets.get("SourceServerName")
SourceDatabaseName =  dbutils.widgets.get("SourceDatabaseName")
tableSchema = dbutils.widgets.get("tableSchema")
tableName = dbutils.widgets.get("tableName")
UniqueIDColumnList = dbutils.widgets.get("UniqueIDColumnList")
DuplicateCheckInRefinedZone = dbutils.widgets.get("DuplicateCheckInRefinedZone")
tablePartitionedByDate = dbutils.widgets.get("tablePartitionedByDate")
tablePartitionColumn = dbutils.widgets.get("tablePartitionColumn")
SoftDeleteCondition = dbutils.widgets.get("SoftDeleteCondition")

SourceRowCount = dbutils.widgets.get("SourceRowCount")
RowCountAuditTolerancePct = dbutils.widgets.get("RowCountAuditTolerancePct")

databricksDatabase= dbutils.widgets.get("databricksDatabase")

ADFName = dbutils.widgets.get("ADFName")
PipelineName = dbutils.widgets.get("PipelineName")
PipelineType = dbutils.widgets.get("PipelineType")
RunId = dbutils.widgets.get("RunId")

scope = dbutils.widgets.get("scope") # to access Key Vault
MedataDataServer = dbutils.widgets.get("MedataDataServer")
MetaDataDatabase = dbutils.widgets.get("MetaDataDatabase")
MetaDataUserID= dbutils.widgets.get("MetaDataUserID")
MetaDataSecretName= dbutils.widgets.get("MetaDataSecretName")




# COMMAND ----------

# DBTITLE 1,Local Variables for testing
"""
import datetime

rawMountPoint = "/mnt/rawzone/"
refinedMountPoint = "mnt/refinedzone"
rawFolder = ""
refinedFolder = ""

SourceServerName = ""
SourceDatabaseName =  ""
tableSchema = "dvo"
tableName = ""
UniqueIDColumnList = "Col1, Col2"
#UniqueIDColumnList = "OrdinalNumber, Col2"  # Bad entries for testing
#DuplicateCheckInRefinedZone = "Y"
tablePartitionedByDate = "Y"
tablePartitionColumn = "CreatedDateTime"
SoftDeleteCondition = "upper(coalesce(OpCode, '')) not in ('X', 'D')"

SourceRowCount = "81324807" 
RowCountAuditTolerancePct = ".0001"

databricksDatabase = ""

ADFName = "TestADF"
PipelineName = "TestPipeline"
PipelineType = "INCR"
RunId = "TestRunID-" + str(datetime.datetime.now())

scope = "bedrock-secrets" # to access Key Vault
MedataDataServer = ""
MetaDataDatabase = ""
MetaDataUserID = ""
MetaDataSecretName = ""
"""

# COMMAND ----------

# DBTITLE 1,Sample Call
"""
dbutils.notebook.run("", 16000, { 
"rawMountPoint" : "/mnt/rawzone/"
,"refinedMountPoint" : "mnt/refinedzone"
,"rawFolder" : ""
,"refinedFolder" : ""

,"SourceServerName" : ""
,"SourceDatabaseName" :  ""
,"tableSchema" : ""
,"tableName" : ""
,"UniqueIDColumnList" : ""
,"DuplicateCheckInRefinedZone" : "Y"
,"tablePartitionedByDate" : "Y"
,"tablePartitionColumn" : "CreatedDateTime"
,"SoftDeleteCondition" : "upper(coalesce(OpCode, '')) not in ('X', 'D')"

,"SourceRowCount" : "81324807"
,"RowCountAuditTolerancePct" : ".0001"

,"databricksDatabase" : ""

,"ADFName" : "TestADF"
,"PipelineName" : "TestPipeline"
,"PipelineType" : "INCR"
,"RunId" : "TestRunID-" 

,"scope" : "TestKeyVaultScope" 
,"MedataDataServer" : "
,"MetaDataDatabase" : ""
,"MetaDataUserID" : ""
,"MetaDataSecretName" : ""
})
"""

# COMMAND ----------

# DBTITLE 1,Capture notebook RunID
import json 
try: 
  notebook_info = json.loads(dbutils.notebook.entry_point.getDbutils().notebook().getContext().toJson())
  #The tag jobId does not exists when the notebook is not triggered by dbutils.notebook.run(...) 
  jobId = notebook_info["tags"]["jobId"] 
  print (jobId)
except Exception as e:
  print (e)
  jobId = -1 

# COMMAND ----------

# DBTITLE 1,Capture clusterOwnerOrgId for Databricks WorkSpace
import json 
try: 
  clusterOwnerOrgId = spark.conf.get("spark.databricks.clusterUsageTags.clusterOwnerOrgId")
  print (clusterOwnerOrgId)
except Exception as e:
  print (e)

# COMMAND ----------

# DBTITLE 1,Format Parameters
ActivityID = "TestActivityID" # This will be updated by ADF after the notebook is executed !

rawMountPoint = rawMountPoint.lower()
refinedMountPoint = refinedMountPoint.lower()
rawFolder = rawFolder.lower()
refinedFolder = refinedFolder.lower()

if rawMountPoint[0] != "/" :
  rawMountPoint = "/" + rawMountPoint
if rawMountPoint[-1] != "/" :
  rawMountPoint = rawMountPoint + "/"

if refinedMountPoint[0] != "/" :
  refinedMountPoint = "/" + refinedMountPoint
if refinedMountPoint[-1] != "/" :
  refinedMountPoint = refinedMountPoint + "/"
  
if rawFolder[0] == "/" :
  rawFolder = rawFolder[1:len(rawFolder)]
if rawFolder[-1] != "/" :
  rawFolder = rawFolder + "/"

if refinedFolder[0] == "/" :
  refinedFolder = refinedFolder[1:len(refinedFolder)]
if refinedFolder[-1] != "/" :
  refinedFolder = refinedFolder + "/"

rawFilePath = rawMountPoint + rawFolder
refinedFilePath = refinedMountPoint + refinedFolder

#DuplicateCheckInRefinedZone = DuplicateCheckInRefinedZone.lower()
tablePartitionedByDate = tablePartitionedByDate.lower()
tablePartitionColumn = tablePartitionColumn.lower()
databricksDatabase = databricksDatabase.lower()

# special rule for  database. if the source database is  then, the databricks database name will be  #
####if (databricksDatabase == ""):
  ###databricksDatabase = ""
  
databricksTableName = databricksDatabase + "." + tableSchema + "_" + tableName
databricksTable = tableSchema + "_" + tableName

print ("UniqueIDColumnList : " + UniqueIDColumnList)
ucl = UniqueIDColumnList.split(',')
print(ucl)
print(len(ucl))
    
print("rawFilePath : " + rawFilePath)
print("refinedFilePath : " + refinedFilePath)

print("tablePartitionedByDate : " + tablePartitionedByDate)
print("tablePartitionColumn : " + tablePartitionColumn)
print("databricksTableName : " + databricksTableName)

# COMMAND ----------

# DBTITLE 1,Assign Default Values
executionStatus = "Failed"
stopExecution = 0
failNotebook = 0
RowsCopied = 0
DuplicateRowCount = 0
FinalTableDuplicateRowCount = 0
TotalRowCountInFinalTable = 0
NumberOfQuarterlyPartitionsProcessed = 0
SourceType = "AzureBlobFS-RawZone"
SinkType = "AzureBlobFS-RefinedZone_DeltaLake"



# COMMAND ----------

# DBTITLE 1,Thread timeout decorator definition
import sys
import threading
try:
    import thread
except ImportError:
    import _thread as thread


def exit_after(s):
    '''
    use as decorator to exit process if 
    function takes longer than s seconds
    '''

    def quit_function(fn_name):
        # print to stderr, unbuffered in Python 2.
        sys.stderr.flush() # Python 3 stderr is likely buffered.
        thread.interrupt_main() # raises KeyboardInterrupt

    def outer(fn):
        def inner(*args, **kwargs):
            timer = threading.Timer(s, quit_function, args=[fn.__name__])
            timer.start()
            try:
                result = fn(*args, **kwargs)
            finally:
                timer.cancel()
            return result
        return inner
    return outer

# COMMAND ----------

# DBTITLE 1,Change Default settings to handle legacy date
# this setting can handle old dates when run on DatBricks 7.4 (includes Apache Spark 3.0.1, Scala 2.12)
spark.conf.set("spark.sql.legacy.parquet.datetimeRebaseModeInRead", 'LEGACY')
spark.conf.set("spark.sql.legacy.parquet.datetimeRebaseModeInWrite", 'LEGACY')
spark.conf.set("set spark.sql.legacy.parquet.int96RebaseModeInRead", 'LEGACY')
spark.conf.set("set spark.sql.legacy.parquet.int96RebaseModeInWrite", 'LEGACY')

# COMMAND ----------

# DBTITLE 1,Capture Start time
import datetime
CopyActivityStartTime = datetime.datetime.now()

# COMMAND ----------

# DBTITLE 1,Setup auth to metadata server
# MAGIC %md
# MAGIC
# MAGIC ###########  ---- Meta data database settings --------------
# MAGIC from pyspark.sql import SparkSession 
# MAGIC spark = SparkSession.builder \
# MAGIC     .master("local") \
# MAGIC     .getOrCreate() 
# MAGIC jdbcHostname = MedataDataServer
# MAGIC jdbcDatabase = MetaDataDatabase
# MAGIC jdbcPort = 1433
# MAGIC jdbcUsername = MetaDataUserID # dbutils.secrets.get(scope = "jdbc", key = "username")
# MAGIC #P1 = dbutils.secrets.get(scope, MetaDataSecretName) # dbutils.secrets.get(scope = "jdbc", key = MetaDataSecretName)
# MAGIC #jdbcUrl = "jdbc:sqlserver://{0}:{1};database={2};user={3};password={4}".format(jdbcHostname, jdbcPort, jdbcDatabase, username, dbutils.secrets.get(scope, MetaDataSecretName))
# MAGIC
# MAGIC jdbcUrl = "jdbc:sqlserver://{0}:{1};database={2}".format(jdbcHostname, jdbcPort, jdbcDatabase)
# MAGIC connectionProperties = {
# MAGIC   "user" : jdbcUsername,
# MAGIC   "password" : dbutils.secrets.get(scope, MetaDataSecretName),
# MAGIC   "driver" : "com.microsoft.sqlserver.jdbc.SQLServerDriver"
# MAGIC }

# COMMAND ----------

# DBTITLE 1,Read Source Data in parquet format - fn definition
# Once in a while, connections to external systems (Azure Storage Account, SQL database, etc )gets stuck. This is a graceful way of exiting.
@exit_after(60 * 60) # the function will kill itself after 1hr

def fn_readRawFiles(FilePath):
  df = (spark.read
    .option("inferschema", "true") 
  #  .schema(rawFileSchema)
     .parquet(FilePath )
    )
  global RowsCopied
  RowsCopied = df.count()
  print ("RowsCopied : " + str(RowsCopied))
  
  return (df)


# COMMAND ----------

# DBTITLE 1,Read Source Data in parquet format - fn exec
from time import sleep
retryCount = 1
retryMax = 2
sleepTime = 1 * 60 # in seconds
previousStatus = "Failed"

if (stopExecution == 0):
  while(retryCount <= retryMax and previousStatus == "Failed"):
    try:
      source_df = fn_readRawFiles(rawFilePath)
      previousStatus = "Passed"
    except Exception as e:
      print (e)
      previousStatus = "Failed"
      retryCount = retryCount + 1
      executionStatus = "Failed - to read from RawZone"
      stopExecution = 1 
      failNotebook = 1
      if (retryCount <= retryMax):
        sleep(sleepTime)
    

# COMMAND ----------

# DBTITLE 1,Audit Source Row Count
if (RowsCopied == 0 and stopExecution == 0 ):
  stopExecution = 1
  print("Stopping Execution")
  executionStatus = "Success - 0 rows to ingest in Incremental Load"

# COMMAND ----------

# DBTITLE 1,Create a stg table with the data to be ingested
if (stopExecution == 0 ):
  try:  
    source_df.createOrReplaceTempView("Stg_RawTable")
  except Exception as e:
    print (e)
    executionStatus = "Failed - Create Stg_RawTable"
    stopExecution = 1 
    failNotebook = 1

# COMMAND ----------

# DBTITLE 1,Check for Duplicate Rows in the source files
if (stopExecution == 0  ):
  try:
    rawTableSqlCmd = "select count( distinct " + UniqueIDColumnList + " ) as DupeCount from ( select "+ UniqueIDColumnList + " , count(*) as RCount from Stg_RawTable group by " + UniqueIDColumnList + " having count(*) >1 ) a "
    print(rawTableSqlCmd)
    DuplicateRowCount = spark.sql(rawTableSqlCmd).first()[0]

    print( "DuplicateRow Count : " + str(DuplicateRowCount) + " @ " + str(datetime.datetime.now())  )
  except Exception as e:
    print (e)
    executionStatus = "Failed - Check for Dupe Rows"
    stopExecution = 1
    failNotebook = 1
    
if (DuplicateRowCount > 0 and stopExecution == 0 ):
  stopExecution = 1
  executionStatus = "Failed - RawDupeRows : " +str(DuplicateRowCount)
  print("Stopping Execution")

# COMMAND ----------

# DBTITLE 1,Delete data from Refined Zone that is also in Incremental (Partitioned & Non Partitioned )
if (stopExecution == 0 ):
  try:
    joinColumns = " "
    for x in ucl:
      joinColumns = joinColumns + " and " + databricksTableName + "." + x.strip() + " = Stg_RawTable."+ x.strip() 
    
    joinColumns = joinColumns[5:]
    print(joinColumns)
    
    DeleteRefinedRowsSql = "MERGE INTO " + databricksTableName + " USING Stg_RawTable ON " + joinColumns + " WHEN MATCHED THEN delete "
    print(DeleteRefinedRowsSql)

    print ("Delete All Start @ " + str(datetime.datetime.now()))
    spark.sql(DeleteRefinedRowsSql)
    print ("Delete All Complete @ " + str(datetime.datetime.now()))
  
  except Exception as e:
    print (e)
    executionStatus = "Failed - Deleting data from existing Table"
    stopExecution = 1
    failNotebook = 1

# COMMAND ----------

# DBTITLE 1,Write Data to Refined Zone - Not Partitioned
if (stopExecution == 0 and tablePartitionedByDate.lower() != "y"):
  try: 
    
    selectRefinedRowsSql = "select * from Stg_RawTable "

    if (SoftDeleteCondition.lower() != "none"):
      selectRefinedRowsSql = selectRefinedRowsSql + " where " + SoftDeleteCondition 

    print (selectRefinedRowsSql)
    
    refinedDF = spark.sql(selectRefinedRowsSql)
    
    (refinedDF
     .write
     .format("delta")
     .mode("append")
     .option("mergeSchema", "true")
     .save(refinedFilePath)
    )
    
  except Exception as e:
    print (e)
    executionStatus = "Failed - Write to Refined Parititioned"
    stopExecution = 1
    failNotebook = 1

# COMMAND ----------

# DBTITLE 1,Write Data to Refined Zone - Partitioned
if (stopExecution == 0 and tablePartitionedByDate.lower() == "y"):
  try: 
    tablePartitionColumn = tablePartitionColumn.lower()

    selectRefinedRowsSql = "select * ,  year(COALESCE(" + tablePartitionColumn + ",'1900-01-01')) as "+ tablePartitionColumn + "_year, year(COALESCE(" + tablePartitionColumn + ",'1900-01-01')) * 10 + quarter(COALESCE(" + tablePartitionColumn + ",'1900-01-01')) as " + tablePartitionColumn + "_quarter from Stg_RawTable "

    if (SoftDeleteCondition.lower() != "none"):
      selectRefinedRowsSql = selectRefinedRowsSql + " where " + SoftDeleteCondition 

    print (selectRefinedRowsSql)
    partitonColumn1 = tablePartitionColumn + "_year" 
    partitonColumn2 = tablePartitionColumn + "_quarter"
    
    refinedDF = spark.sql(selectRefinedRowsSql)
    
    (refinedDF
     .write
     .format("delta")
     .partitionBy(partitonColumn1,partitonColumn2)
     .mode("append")
     .option("mergeSchema", "true")
     .save(refinedFilePath)
    )
    
  except Exception as e:
    print (e)
    executionStatus = "Failed - Write to Refined Parititioned"
    stopExecution = 1
    failNotebook = 1

# COMMAND ----------

# DBTITLE 1,Update & Audit external table - fn definition
@exit_after(60 * 60) # the function will kill itself after 60 min

def fn_UpdateAndAuditExternalTable(databricksDatabase, databricksTableName, tablePartitionedByDate):
   
  if (tablePartitionedByDate.lower() == "y" ):
    TableSqlCmd = "fsck repair table " + databricksTableName 
    print(TableSqlCmd)
    spark.sql(TableSqlCmd)
  
  if (tablePartitionedByDate.lower() != "y" ):
    TableSqlCmd = "refresh table " + databricksTableName 
    print(TableSqlCmd)
    spark.sql(TableSqlCmd)
    
  selectRefinedRowsSql = "select count(*) as RCount from " + databricksTableName 
  global TotalRowCountInFinalTable
  TotalRowCountInFinalTable = spark.sql(selectRefinedRowsSql).select("RCount").first()[0]
  print("TotalRowCountInFinalTable : " + str(TotalRowCountInFinalTable))
  
  rawTableSqlCmd = "select count( distinct " + UniqueIDColumnList + " ) as DupeCount from ( select "+ UniqueIDColumnList + " , count(*) as RCount from " + databricksTableName + " group by " + UniqueIDColumnList + " having count(*) >1 ) a "
  print(rawTableSqlCmd)
  
  global FinalTableDuplicateRowCount
  FinalTableDuplicateRowCount = spark.sql(rawTableSqlCmd).first()[0]
  print("FinalTableDuplicateRowCount : " + str(FinalTableDuplicateRowCount))
  
  return()

# COMMAND ----------

# DBTITLE 1,Update & Audit external table - fn exec
from time import sleep
retryCount = 1
retryMax = 2
sleepTime = 10 * 60 # in seconds
previousStatus = "Failed"

if (stopExecution == 0):
  while(retryCount <= retryMax and previousStatus == "Failed"):
    try:
      fn_UpdateAndAuditExternalTable(databricksDatabase, databricksTableName, tablePartitionedByDate)
      previousStatus = "Passed"
    except Exception as e:
      print (e)
      previousStatus = "Failed"
      retryCount = retryCount + 1
      executionStatus = "Failed - to read from RefinedZone"
      stopExecution = 1 
      failNotebook = 1
      if (retryCount <= retryMax):
        sleep(sleepTime)

# COMMAND ----------

# DBTITLE 1,Audit Duplicates in Final Table
if (stopExecution == 0 and FinalTableDuplicateRowCount > 0):
  stopExecution = 1
  executionStatus = "Failed - RefinedDupeRows : " +str(FinalTableDuplicateRowCount)
  
  print(executionStatus)


# COMMAND ----------

# DBTITLE 1,Audit Source Row Count against Refined Table
if (stopExecution == 0):
  try:
    SourceRowCount = int(SourceRowCount)
    RowCountAuditTolerancePct  = float(RowCountAuditTolerancePct) 
    
    if SourceRowCount > 0 :
      Variance =  (SourceRowCount - TotalRowCountInFinalTable) / SourceRowCount
    else:
      Variance = 1
    print (abs(Variance))
    
    if SourceRowCount != TotalRowCountInFinalTable:
      #abs(Variance) > RowCountAuditTolerancePct :
      print (SourceRowCount)
      print (TotalRowCountInFinalTable)
      print (RowCountAuditTolerancePct)
      print (Variance)
      executionStatus = "Warning-stp1-SrcRows: " + str(SourceRowCount)
      print (executionStatus)
      stopExecution = 1
    else:
      executionStatus = "Success"
      
  except Exception as e:
    print (e)
    executionStatus = "Failed - Checking SourceRowCount"
    stopExecution = 1
    failNotebook = 1

# COMMAND ----------

# DBTITLE 1,Capture End time
import datetime
CopyActivityEndTime = datetime.datetime.now()

# COMMAND ----------

# DBTITLE 1,Fail the Notebook if there is a previous failure
if (failNotebook != 0):
  x = 1/0

# COMMAND ----------

# DBTITLE 1,Pass Output Parameters from Notebook to ADF
dbutils.notebook.exit(str(CopyActivityEndTime)+"|"+str(refinedFilePath)+"|"+str(TotalRowCountInFinalTable)+"|"+str(CopyActivityStartTime)+"|"+str(executionStatus))
