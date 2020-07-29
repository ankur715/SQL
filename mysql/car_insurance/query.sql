USE pbrown;

SHOW TABLES;

SHOW FULL TABLES;
SELECT * FROM address;

CREATE VIEW married 
AS 
SELECT ID, FName, LName, MaritalStatus, Dependants 
FROM customer; 

SHOW FULL TABLES;

SHOW TABLES LIKE 'c%';

SHOW TABLES LIKE '%er';

SHOW FULL TABLES WHERE table_type = 'VIEW';

SHOW TABLES FROM mysql LIKE 'time%';

SHOW TABLES IN mysql LIKE 'time%';

SELECT * FROM INFORMATION_SCHEMA.TABLES;

SELECT COUNT(*) as total FROM 
	(SELECT TABLE_NAME as tab, TABLES.* 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA='pbrown' GROUP BY tab) 
tables;

SELECT TABLE_NAME as tab, TABLES.* 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA='pbrown' GROUP BY tab;


-- querying information_schema.tables
/*
SELECT ic.Table_Name,
    ic.Column_Name,
    ic.data_Type,
    IFNULL(Character_Maximum_Length,'') AS `Max`,
    ic.Numeric_precision as `Precision`,
    ic.numeric_scale as Scale,
    ic.Character_Maximum_Length as VarCharSize,
    ic.is_nullable as Nulls, 
    ic.ordinal_position as OrdinalPos, 
    ic.column_default as ColDefault, 
    ku.ordinal_position as PK,
    kcu.constraint_name,
    kcu.ordinal_position,
    tc.constraint_type
FROM INFORMATION_SCHEMA.COLUMNS ic
    left outer join INFORMATION_SCHEMA.key_column_usage ku
        on ku.table_name = ic.table_name
        and ku.column_name = ic.column_name
    left outer join information_schema.key_column_usage kcu
        on kcu.column_name = ic.column_name
        and kcu.table_name = ic.table_name
    left outer join information_schema.table_constraints tc
        on kcu.constraint_name = tc.constraint_name
order by ic.table_name, ic.ordinal_position;
*/
SHOW TABLES;
SELECT * FROM customer;
SELECT * FROM policy;
SELECT Title, FName as 'First Name' FROM customer;
SELECT DATE_FORMAT(PolicyEndDate, '%m/%d/%Y') as 'Policy End Date' FROM policy;
SELECT PolicyEndDate FROM policy;
SELECT DATE_FORMAT(CURDATE(), '%m/%d/%Y') as 'Todays Date' FROM policy;
 
SELECT Title, FName as 'First Name', LName as 'Last Name', 
		EmailAddress, customer.TelephoneNumber,
        DATE_FORMAT(PolicyEndDate, '%m/%d/%Y') as 'Policy End Date', 
        DATE_FORMAT(CURDATE(), '%m/%d/%Y') as 'Todays Date', 
        policy.ID  as "Policy ID" , VehicleReg
FROM customer
LEFT JOIN policy on customer.ID = policy.CustomerID
WHERE PolicyEndDate BETWEEN DATE_SUB(NOW(), INTERVAL 50 DAY) AND now();

