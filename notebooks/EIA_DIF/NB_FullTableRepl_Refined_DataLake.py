# Databricks notebook source
# DBTITLE 1,Legend
"""
service name :  
notebook name : NB_FullTableRepl_Refined_DataLake
objective : This notebook handles the full load of tables to Refined Zone in Delta Lake format. The source data will be traditional parquet format in the rawzone.
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
tableSchema = "dbo"
tableName = ""
UniqueIDColumnList = ""
#UniqueIDColumnList = "OrdinalNumber, Col2"  # Bad entries for testing
DuplicateCheckInRefinedZone = "Y"
tablePartitionedByDate = "Y"
tablePartitionColumn = "CreatedDateTime"
SoftDeleteCondition = "upper(coalesce(OpCode, '')) not in ('X', 'D')"

SourceRowCount = "81302056"
RowCountAuditTolerancePct = ".0001"

databricksDatabase = ""

ADFName = "TestADF"
PipelineName = "TestPipeline"
PipelineType = "FULL"
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
,"tableSchema" : "dbo"
,"tableName" : ""
,"UniqueIDColumnList" : ""
,"DuplicateCheckInRefinedZone" : "Y"
,"tablePartitionedByDate" : "Y"
,"tablePartitionColumn" : "CreatedDateTime"
,"SoftDeleteCondition" : "upper(coalesce(OpCode, '')) not in ('X', 'D')"

,"SourceRowCount" : "81302056"
,"RowCountAuditTolerancePct" : ".0001"

,"databricksDatabase" : ""

,"ADFName" : "TestADF"
,"PipelineName" : "TestPipeline"
,"PipelineType" : "FULL"
,"RunId" : "TestRunID-" 

,"scope" : "bedrock-secrets" 
,"MedataDataServer" : ""
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

DuplicateCheckInRefinedZone = DuplicateCheckInRefinedZone.lower()
tablePartitionedByDate = tablePartitionedByDate.lower()
tablePartitionColumn = tablePartitionColumn.lower()
databricksDatabase = databricksDatabase.lower()
# special rule for  database. if the source database is  then, the databricks database name will be  #
###if (databricksDatabase == ""):
  ###databricksDatabase = ""
  
databricksTableName = databricksDatabase + "." + tableSchema + "_" + tableName
databricksTable = tableSchema + "_" + tableName

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
  executionStatus = "Failed - 0 rows to ingest in Full Load"

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
if (stopExecution == 0 and DuplicateCheckInRefinedZone == "y" ):
  try:
    print (UniqueIDColumnList)
    ucl = UniqueIDColumnList.split(',')
    print(ucl)
    print(len(ucl))
    rawTableSqlCmd = "select count( distinct " + UniqueIDColumnList + " ) as DupeCount from ( select "+ UniqueIDColumnList + " , count(*) as RCount from Stg_RawTable group by " + UniqueIDColumnList + " having count(*) >1 ) a "
    print(rawTableSqlCmd)
    DuplicateRowCount = spark.sql(rawTableSqlCmd).first()[0]

    print( "DuplicateRow Count : " + str(DuplicateRowCount) + " @ " + str(datetime.datetime.now())  )
  except Exception as e:
    print (e)
    executionStatus = "Failed - Check for Dupe Rows"
    stopExecution = 1
    failNotebook = 1
    
if (DuplicateRowCount > 0 and stopExecution == 0  and DuplicateCheckInRefinedZone == "y" ):
  stopExecution = 1
  executionStatus = "Failed - DupeRows : " +str(DuplicateRowCount)
  print("Stopping Execution")

# COMMAND ----------

# DBTITLE 1,Delete Destination Folder since its a full load  - fn definition
"""
dbutils.fs.rm(mountRefinedPath, recurse = True)

Ideally one should be able to call the function above. However, if the folder has subfolders inside, we are getting an error
shaded.databricks.org.apache.hadoop.fs.azure.AzureException: hadoop_azure_shaded.com.microsoft.azure.storage.StorageException: This operation is not permitted on a non-empty directory.
  hence making a recursive call.
"""
# Once in a while, connections to external systems (Azure Storage Account, SQL database, etc )gets stuck. This is a graceful way of exiting.
@exit_after(30 * 60) # the function will kill itself after 30 min

def delete_recursive (path: str):
  li = sorted( dbutils.fs.ls(path), reverse = True)

  for x in li:
      if x.path[-1] == '/':
        delete_recursive (x.path)
        
  try :
    print ("deleting : " + path)
    dbutils.fs.rm(path,  recurse = True)  
  except Exception as e:
    print (e)

# COMMAND ----------

# DBTITLE 1, Delete Destination Folder since its a full load  - fn exec -- Do not do this if time travel in Delta Lake is needed !!!
from time import sleep
retryCount = 1
retryMax = 2
sleepTime = 5 * 60 # in seconds
previousStatus = "Failed"

if (stopExecution == 0):
  while(retryCount <= retryMax and previousStatus == "Failed"):
    try:
      delete_recursive(refinedFilePath)
      previousStatus = "Passed"
    except Exception as e:
      print (e)
      previousStatus = "Failed"
      retryCount = retryCount + 1
      #executionStatus = "Failed - to predelete RefinedZone"
      stopExecution = 0  # If the table is created for the first time, this delete will fail, so this is an expected outcome
      failNotebook = 0
      if (retryCount <= retryMax):
        sleep(sleepTime)

# COMMAND ----------

# DBTITLE 1,Write Data to Refined Zone - NOT Partitioned
if (stopExecution == 0 and tablePartitionedByDate.lower() != "y"):
  try:
    print("Table not partitioned by date")
    NumberOfQuarterlyPartitionsProcessed = 0

    selectRefinedRowsSql = "select * from Stg_RawTable "

    if (SoftDeleteCondition.lower() != "none"):
      print (SoftDeleteCondition)
      selectRefinedRowsSql = selectRefinedRowsSql + " where " + SoftDeleteCondition

    print (selectRefinedRowsSql)

    refinedDF = spark.sql(selectRefinedRowsSql)
    (refinedDF
       .write
       .format("delta")
       .mode("overwrite")
       .save(refinedFilePath)   
    )
    
  except Exception as e:
    print (e)
    executionStatus = "Failed - Write to Refined Non Partitioned"
    stopExecution = 1
    failNotebook = 1

# COMMAND ----------

# DBTITLE 1,Write Data to Refined Zone - Partitioned
######### ---- Write the files to refined Zone -------------
if (stopExecution == 0 and tablePartitionedByDate.lower() == "y"):
    ### -- Table is partitioned by Date and has PatientSID Column and not a dimension table -------------------
    
  try:
    tablePartitionColumn = tablePartitionColumn.lower()

    selectRefinedRowsSql = "select * ,  year(COALESCE(" + tablePartitionColumn + ",'1900-01-01')) as "+ tablePartitionColumn + "_year, year(COALESCE(" + tablePartitionColumn + ",'1900-01-01')) * 10 + quarter(COALESCE(" + tablePartitionColumn + ",'1900-01-01')) as " + tablePartitionColumn + "_quarter from Stg_RawTable "

    print("tablePartitionedByDate == y :")  

    if (SoftDeleteCondition.lower() != "none"):
      print (SoftDeleteCondition)
      selectRefinedRowsSql = selectRefinedRowsSql + " where " + SoftDeleteCondition 

    print (selectRefinedRowsSql)
    partitonColumn1 = tablePartitionColumn + "_year" 
    partitonColumn2 = tablePartitionColumn + "_quarter"

    refinedDF = spark.sql(selectRefinedRowsSql)

    NumberOfQuarterlyPartitionsProcessed =  refinedDF.select(partitonColumn2).distinct().count()
    print( "NumberOfQuarterlyPartitionsProcessed Count : " + str(NumberOfQuarterlyPartitionsProcessed) + " @ " + str(datetime.datetime.now())  )

    (refinedDF
       .write
       .format("delta")
       .partitionBy(partitonColumn1,partitonColumn2)
       .mode("overwrite")
       .save(refinedFilePath)
    )

  except Exception as e:
    print (e)
    executionStatus = "Failed - Write to Refined Parititioned"
    stopExecution = 1
    failNotebook = 1

# COMMAND ----------

# DBTITLE 1,Drop & Create external table - fn definition
@exit_after(45 * 60) # the function will kill itself after 45 min

def fn_CreateExternalTable(databricksDatabase, databricksTableName, tablePartitionedByDate, refinedFilePath):

  TableSqlCmd = " Create Database IF NOT EXISTS " + databricksDatabase 
  print(TableSqlCmd)
  spark.sql(TableSqlCmd) 
  
  TableSqlCmd = " Drop TABLE IF  EXISTS " + databricksTableName 
  print(TableSqlCmd)
  spark.sql(TableSqlCmd) 
  
  TableSqlCmd = " CREATE TABLE IF NOT EXISTS " + databricksTableName + " USING delta OPTIONS (path = '{}') "
  print(TableSqlCmd)
  spark.sql(TableSqlCmd.format(refinedFilePath))
  
  if (tablePartitionedByDate.lower() == "y" ):
    TableSqlCmd = "fsck repair table " + databricksTableName 
    print(TableSqlCmd)
    spark.sql(TableSqlCmd)
    
  selectRefinedRowsSql = "select count(*) as RCount from " + databricksTableName 
  DeltaLakeTableRowCount = spark.sql(selectRefinedRowsSql).select("RCount").first()[0]
  print("DeltaLakeTableRowCount : " + str(DeltaLakeTableRowCount))
  
  return(DeltaLakeTableRowCount)
  
  

# COMMAND ----------

# DBTITLE 1,Drop & Create external table - fn exec
from time import sleep
retryCount = 1
retryMax = 2
sleepTime = 10 * 60 # in seconds
previousStatus = "Failed"

if (stopExecution == 0):
  while(retryCount <= retryMax and previousStatus == "Failed"):
    try:
      TotalRowCountInFinalTable = fn_CreateExternalTable(databricksDatabase, databricksTableName, tablePartitionedByDate, refinedFilePath)
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
    
    if SourceRowCount != TotalRowCountInFinalTable :
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

# DBTITLE 1,Pass Output Parameters to ADF from Notebook
dbutils.notebook.exit(str(CopyActivityEndTime)+"|"+str(refinedFilePath)+"|"+str(TotalRowCountInFinalTable)+"|"+str(CopyActivityStartTime)+"|"+str(executionStatus))
