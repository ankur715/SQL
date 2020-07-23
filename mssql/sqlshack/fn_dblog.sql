-- use undocumented function fn_dblog to get information about delete and truncate statements from the transaction log
USE SQLShackDemo;
GO
SELECT [Current LSN], 
       [transaction ID] tranID, 
       [begin time], 
       Description, 
       operation, 
       Context
FROM ::fn_dbLog(NULL, NULL)
WHERE [Transaction Name] IN('Delete', 'Truncate table');

-- can note down the begin time of these transaction


-- In the full recovery model, transaction log backup maintains the log chain. 
-- We can also do point in time recovery using transaction log backup.
Backup log SQLShackDemo to disk='C:\temp\SQLShackDemo_log.trn'


