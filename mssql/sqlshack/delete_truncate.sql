-- delete a few records from [DeletemyData] table
DELETE FROM [DeletemyData]
WHERE id < 5;

-- cannot specify the WHERE clause in truncate, so it removes all records from a table
Truncate table TruncatemyData;

SELECT * FROM DeletemyData;
SELECT * FROM TruncatemyData;
