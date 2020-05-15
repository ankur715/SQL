-- Connect to the instance where you installed Machine Learning Services, 
-- click New Query to open a query window, and run the following command:
sp_configure
-- The value for the property, external scripts enabled, should be 0 at this point.

-- To enable the external scripting feature, run the following statement:
EXEC sp_configure  'external scripts enabled', 1
RECONFIGURE WITH OVERRIDE
