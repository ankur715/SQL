---------- CREATE DATABASE ----------

CREATE DATABASE TestDb;



---------- DROP DATABASE ----------

DROP DATABASE IF EXISTS TestDb;



---------- CREATE SCHEMA ----------

CREATE SCHEMA customer_services;
GO


SELECT 
    s.name AS schema_name, 
    u.name AS schema_owner
FROM 
    sys.schemas s
INNER JOIN sys.sysusers u ON u.uid = s.principal_id
ORDER BY 
    s.name;


CREATE TABLE customer_services.jobs(
    job_id INT PRIMARY KEY IDENTITY,
    customer_id INT NOT NULL,
    description VARCHAR(200),
    created_at DATETIME2 NOT NULL
);



---------- ALTER SCHEME ----------

CREATE TABLE dbo.offices
(
    office_id      INT
    PRIMARY KEY IDENTITY, 
    office_name    NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone          VARCHAR(20),
);


INSERT INTO 
    dbo.offices(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');


CREATE PROCEDURE usp_get_office_by_id(
    @id INT
) AS
BEGIN
    SELECT 
        * 
    FROM 
        dbo.offices
    WHERE 
        office_id = @id;
END;


ALTER SCHEMA sales TRANSFER OBJECT::dbo.offices;


ALTER PROCEDURE usp_get_office_by_id(
    @id INT
) AS
BEGIN
    SELECT 
        * 
    FROM 
        sales.offices
    WHERE 
        office_id = @id;
END;



---------- DROP SCHEMA ----------

CREATE TABLE logistics.deliveries
(
    order_id        INT
    PRIMARY KEY, 
    delivery_date   DATE NOT NULL, 
    delivery_status TINYINT NOT NULL
);

DROP SCHEMA logistics;

DROP TABLE logistics.deliveries;

DROP SCHEMA IF EXISTS logistics;



---------- CREATE TABLE ----------

CREATE TABLE sales.visits (
    visit_id INT PRIMARY KEY IDENTITY (1, 1),
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    visited_at DATETIME,
    phone VARCHAR(20),
    store_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);



---------- IDENTIFY COLUMN ----------

CREATE SCHEMA hr;


CREATE TABLE hr.person (
    person_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL
);

INSERT INTO hr.person(first_name, last_name, gender)
OUTPUT inserted.person_id
VALUES('John','Doe', 'M');


INSERT INTO hr.person(first_name, last_name, gender)
OUTPUT inserted.person_id
VALUES('Jane','Doe','F');


CREATE TABLE hr. POSITION (
	position_id INT IDENTITY (1, 1) PRIMARY KEY,
	position_name VARCHAR (255) NOT NULL,

);

CREATE TABLE hr.person_position (
	person_id INT,
	position_id INT,
	PRIMARY KEY (person_id, position_id),
	FOREIGN KEY (person_id) REFERENCES hr.person (person_id),
	FOREIGN KEY (position_id) REFERENCES hr. POSITION (position_id)
);


BEGIN TRANSACTION
    BEGIN TRY
        -- insert a new person
        INSERT INTO hr.person(first_name,last_name, gender)
        VALUES('Joan','Smith','F');

        -- assign the person a position
        INSERT INTO hr.person_position(person_id, position_id)
        VALUES(@@IDENTITY, 1);
    END TRY
    BEGIN CATCH
         IF @@TRANCOUNT > 0  
            ROLLBACK TRANSACTION;  
    END CATCH

    IF @@TRANCOUNT > 0  
        COMMIT TRANSACTION;
GO


INSERT INTO hr.person(first_name,last_name,gender)
OUTPUT inserted.person_id
VALUES('Peter','Drucker','F');



---------- SEQUENCE ----------

CREATE SEQUENCE item_counter
    AS INT
    START WITH 10
    INCREMENT BY 10;


SELECT NEXT VALUE FOR item_counter;

SELECT NEXT VALUE FOR item_counter;


CREATE SCHEMA procurement;
GO


CREATE TABLE procurement.purchase_orders(
    order_id INT PRIMARY KEY,
    vendor_id int NOT NULL,
    order_date date NOT NULL
);


CREATE SEQUENCE procurement.order_number 
AS INT
START WITH 1
INCREMENT BY 1;


INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,1,'2019-04-30');


INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,2,'2019-05-01');


INSERT INTO procurement.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR procurement.order_number,3,'2019-05-02');


SELECT 
    order_id, 
    vendor_id, 
    order_date
FROM 
    procurement.purchase_orders;


CREATE SEQUENCE procurement.receipt_no
START WITH 1
INCREMENT BY 1;


CREATE TABLE procurement.goods_receipts
(
    receipt_id   INT	PRIMARY KEY 
        DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
    order_id     INT NOT NULL, 
    full_receipt BIT NOT NULL,
    receipt_date DATE NOT NULL,
    note NVARCHAR(100),
);


CREATE TABLE procurement.invoice_receipts
(
    receipt_id   INT PRIMARY KEY
        DEFAULT (NEXT VALUE FOR procurement.receipt_no), 
    order_id     INT NOT NULL, 
    is_late      BIT NOT NULL,
    receipt_date DATE NOT NULL,
    note NVARCHAR(100)
);


INSERT INTO procurement.goods_receipts(
    order_id, 
    full_receipt,
    receipt_date,
    note
)
VALUES(
    1,
    1,
    '2019-05-12',
    'Goods receipt completed at warehouse'
);
INSERT INTO procurement.goods_receipts(
    order_id, 
    full_receipt,
    receipt_date,
    note
)
VALUES(
    1,
    0,
    '2019-05-12',
    'Goods receipt has not completed at warehouse'
);

INSERT INTO procurement.invoice_receipts(
    order_id, 
    is_late,
    receipt_date,
    note
)
VALUES(
    1,
    0,
    '2019-05-13',
    'Invoice duly received'
);
INSERT INTO procurement.invoice_receipts(
    order_id, 
    is_late,
    receipt_date,
    note
)
VALUES(
    2,
    0,
    '2019-05-15',
    'Invoice duly received'
);


SELECT * FROM procurement.goods_receipts;
SELECT * FROM procurement.invoice_receipts;



---------- ADD COLUMN ----------

CREATE TABLE sales.quotations (
    quotation_no INT IDENTITY PRIMARY KEY,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
);


ALTER TABLE sales.quotations 
ADD description VARCHAR (255) NOT NULL;


ALTER TABLE sales.quotations 
    ADD 
        amount DECIMAL (10, 2) NOT NULL,
        customer_name VARCHAR (50) NOT NULL;



---------- MODIFY COLUMN ----------

CREATE TABLE t1 (c INT);

INSERT INTO t1
    VALUES
        (1),
        (2),
        (3);


ALTER TABLE t1 ALTER COLUMN c VARCHAR (2);


INSERT INTO t1
VALUES ('@');


ALTER TABLE t1 ALTER COLUMN c INT;


CREATE TABLE t2 (c VARCHAR(10));

INSERT INTO t2
VALUES
    ('SQL Server'),
    ('Modify'),
    ('Column')


ALTER TABLE t2 ALTER COLUMN c VARCHAR (50);

ALTER TABLE t2 ALTER COLUMN c VARCHAR (5);

CREATE TABLE t3 (c VARCHAR(50));

INSERT INTO t3
VALUES
    ('Nullable column'),
    (NULL);


UPDATE t3
SET c = ''
WHERE
    c IS NULL;


ALTER TABLE t3 ALTER COLUMN c VARCHAR (20) NOT NULL;



---------- DROP COLUMN ----------

CREATE TABLE sales.price_lists(
    product_id int,
    valid_from DATE,
    price DEC(10,2) NOT NULL CONSTRAINT ck_positive_price CHECK(price >= 0),
    discount DEC(10,2) NOT NULL,
    surcharge DEC(10,2) NOT NULL,
    note VARCHAR(255),
    PRIMARY KEY(product_id, valid_from)
);


ALTER TABLE sales.price_lists
DROP COLUMN note;


ALTER TABLE sales.price_lists
DROP COLUMN price;


ALTER TABLE sales.price_lists
DROP CONSTRAINT ck_positive_price;


ALTER TABLE sales.price_lists
DROP COLUMN price;


ALTER TABLE sales.price_lists
DROP COLUMN discount, surcharge;


---------- COMPUTED COLUMNS ----------

CREATE TABLE persons
(
    person_id  INT PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL, 
    dob        DATE
);


INSERT INTO 
    persons(first_name, last_name, dob)
VALUES
    ('John','Doe','1990-05-01'),
    ('Jane','Doe','1995-03-01');


SELECT
    person_id,
    first_name + ' ' + last_name AS full_name,
    dob
FROM
    persons
ORDER BY
    full_name;


ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name);


SELECT 
    person_id, 
    full_name, 
    dob
FROM 
    persons
ORDER BY 
    full_name;


ALTER TABLE persons
DROP COLUMN full_name;


ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name) PERSISTED;


ALTER TABLE persons
ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000 
PERSISTED;


ALTER TABLE persons
ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000;


	SELECT 
    person_id, 
    full_name, 
    age_in_years
FROM 
    persons
ORDER BY 
    age_in_years DESC;


SELECT 
    person_id, 
    full_name, 
    age_in_years
FROM 
    persons
ORDER BY 
    age_in_years DESC;



---------- RENAME TABLE ----------

CREATE TABLE sales.contr (
    contract_no INT IDENTITY PRIMARY KEY,
    start_date DATE NOT NULL,
    expired_date DATE,
    customer_id INT,
    amount DECIMAL (10, 2)
);


EXEC sp_rename 'sales.contr', 'contracts';



---------- DROP TABLE ----------

DROP TABLE IF EXISTS sales.revenues;

CREATE TABLE sales.delivery (
    delivery_id INT PRIMARY KEY,
    delivery_note VARCHAR (255) NOT NULL,
    delivery_date DATE NOT NULL
);


DROP TABLE sales.delivery;


CREATE SCHEMA procurement;
GO

CREATE TABLE procurement.supplier_groups (
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (50) NOT NULL
);

CREATE TABLE procurement.suppliers (
    supplier_id INT IDENTITY PRIMARY KEY,
    supplier_name VARCHAR (50) NOT NULL,
    group_id INT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES procurement.supplier_groups (group_id)
);


DROP TABLE procurement.supplier_groups;


DROP TABLE procurement.supplier_groups;
DROP TABLE procurement.suppliers;

DROP TABLE procurement.suppliers, procurement.supplier_groups;



---------- TRUNCATE TABLE ----------

CREATE TABLE sales.customer_groups (
    group_id INT PRIMARY KEY IDENTITY,
    group_name VARCHAR (50) NOT NULL
);

INSERT INTO sales.customer_groups (group_name)
VALUES
    ('Intercompany'),
    ('Third Party'),
    ('One time');


DELETE FROM sales.customer_groups;


TRUNCATE TABLE [database_name.][schema_name.]table_name;


INSERT INTO sales.customer_groups (group_name)
VALUES
    ('Intercompany'),
    ('Third Party'),
    ('One time');   

TRUNCATE TABLE sales.customer_groups;



---------- TEMPORARY TABLES ----------

SELECT
    product_name,
    list_price
INTO #trek_products --- temporary table
FROM
    production.products
WHERE
    brand_id = 9;


CREATE TABLE #haro_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);


INSERT INTO #haro_products
SELECT
    product_name,
    list_price
FROM 
    production.products
WHERE
    brand_id = 2;


SELECT
    *
FROM
    #haro_products;


CREATE TABLE ##heller_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO ##heller_products
SELECT
    product_name,
    list_price
FROM 
    production.products
WHERE
    brand_id = 3;


DROP TABLE ##table_name;



---------- SYNONYM ----------

CREATE SYNONYM orders FOR sales.orders;

SELECT * FROM orders;


CREATE DATABASE test;
GO

USE test;
GO


CREATE SCHEMA purchasing;
GO


CREATE TABLE purchasing.suppliers
(
    supplier_id   INT
    PRIMARY KEY IDENTITY, 
    supplier_name NVARCHAR(100) NOT NULL
);


CREATE SYNONYM suppliers 
FOR test.purchasing.suppliers;


SELECT * FROM suppliers;


SELECT 
    name, 
    base_object_name, 
    type
FROM 
    sys.synonyms
ORDER BY 
    name;


DROP SYNONYM IF EXISTS orders;



---------- SELECT INTO ----------

CREATE SCHEMA marketing;
GO


SELECT 
    *
INTO 
    marketing.customers
FROM 
    sales.customers;


SELECT 
    *
FROM 
    marketing.customers;


CREATE DATABASE TestDb;
GO


SELECT    
    customer_id, 
    first_name, 
    last_name, 
    email
INTO 
    TestDb.dbo.customers
FROM    
    sales.customers
WHERE 
    state = 'CA';


SELECT 
    * 
FROM 
    TestDb.dbo.customers;



---------- PRIMARY KEY ----------

CREATE TABLE table_name (
    pk_column_1 data_type,
    pk_column_2 data type,
    ...
    PRIMARY KEY (pk_column_1, pk_column_2)
);


CREATE TABLE sales.activities (
    activity_id INT PRIMARY KEY IDENTITY,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
);


CREATE TABLE sales.participants(
    activity_id int,
    customer_id int,
    PRIMARY KEY(activity_id, customer_id)
);


CREATE TABLE sales.events(
    event_id INT NOT NULL,
    event_name VARCHAR(255),
    start_date DATE NOT NULL,
    duration DEC(5,2)
);


ALTER TABLE sales.events 
ADD PRIMARY KEY(event_id);



---------- FOREIGN KEY ----------

CREATE TABLE procurement.vendor_groups (
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (100) NOT NULL
);

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
);


DROP TABLE vendors;

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id)
);


INSERT INTO procurement.vendors(vendor_name, group_id)
VALUES('ABC Corp',1);

INSERT INTO procurement.vendors(vendor_name, group_id)
VALUES('XYZ Corp',4);



---------- CHECK Constraint ----------

CREATE SCHEMA test;
GO

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
);


CHECK(unit_price > 0)


CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CONSTRAINT positive_price CHECK(unit_price > 0)
);


INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Free Bike', 0);


INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Bike', 599);


INSERT INTO test.products(product_name, unit_price)
VALUES ('Another Awesome Bike', NULL);


CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0),
    discounted_price DEC(10,2) CHECK(discounted_price > 0),
    CHECK(discounted_price < unit_price)
);


CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CHECK(discounted_price > unit_price)
);


CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0 AND discounted_price > unit_price)
);


CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CONSTRAINT valid_prices CHECK(discounted_price > unit_price)
);


CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) NOT NULL
);


ALTER TABLE test.products
ADD CONSTRAINT positive_price CHECK(unit_price > 0);


ALTER TABLE test.products
ADD discounted_price DEC(10,2)
CHECK(discounted_price > 0);


ALTER TABLE test.products
ADD CONSTRAINT valid_price 
CHECK(unit_price > discounted_price);


ALTER TABLE table_name
DROP CONSTRAINT constraint_name;


EXEC sp_help 'table_name';


EXEC sp_help 'test.products';


ALTER TABLE test.products
DROP CONSTRAINT positive_price;


ALTER TABLE table_name
NOCHECK CONSTRAINT constraint_name;


ALTER TABLE test.products
NO CHECK CONSTRAINT valid_price;



---------- UNIQUE Constraint ----------

CREATE SCHEMA hr;
GO

CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);


CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    UNIQUE(email)
);


INSERT INTO hr.persons(first_name, last_name, email)
VALUES('John','Doe','j.doe@bike.stores');


INSERT INTO hr.persons(first_name, last_name, email)
VALUES('Jane','Doe','j.doe@bike.stores');


CREATE TABLE hr.persons (
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    CONSTRAINT unique_email UNIQUE(email)
);


INSERT INTO hr.persons(first_name, last_name)
VALUES('John','Smith');


INSERT INTO hr.persons(first_name, last_name)
VALUES('Lily','Bush');


CREATE TABLE table_name (
    key_column data_type PRIMARY KEY,
    column1 data_type,
    column2 data_type,
    column3 data_type,
    ...,
    UNIQUE (column1,column2)
);


CREATE TABLE hr.person_skills (
    id INT IDENTITY PRIMARY KEY,
    person_id int,
    skill_id int,
    updated_at DATETIME,
    UNIQUE (person_id, skill_id)
);


ALTER TABLE table_name
ADD CONSTRAINT constraint_name 
UNIQUE(column1, column2,...);


CREATE TABLE hr.persons (
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
);


ALTER TABLE hr.persons
ADD CONSTRAINT unique_email UNIQUE(email);


ALTER TABLE hr.persons
ADD CONSTRAINT unique_phone UNIQUE(phone);


ALTER TABLE table_name
DROP CONSTRAINT constraint_name;


ALTER TABLE hr.persons
DROP CONSTRAINT unique_phone;



---------- NOT NULL Constraint ----------

CREATE SCHEMA hr;
GO

CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);


UPDATE hr.persons
SET phone = "(408) 123 4567"
WHER phone IS NULL;


ALTER TABLE hr.persons
ALTER COLUMN phone VARCHAR(20) NOT NULL;


ALTER TABLE table_name
ALTER COLUMN column_name data_type NULL;


ALTER TABLE hr.pesons
ALTER COLUMN phone VARCHAR(20) NULL;



