--------------------------------------------------------------------------------------------------------
-- https://platform.stratascratch.com/coding?code_type=5&is_freemium=1
--------------------------------------------------------------------------------------------------------

/*
Most Profitable Companies
Find the 3 most profitable companies in the entire world.
Output the result along with the corresponding company name.
Sort the result based on profits in descending order.
*/
-- select * from forbes_global_2010_2014;
select top 3 company, profits
from forbes_global_2010_2014
order by profits desc;


/*
Workers With The Highest Salaries
You have been asked to find the job titles of the highest-paid employees.
Your output should include the highest-paid title or multiple titles with the same salary.
*/
-- select * from worker;
select worker_title, max(salary)
from worker
join title 
on worker.worker_id = title.worker_ref_id
group by worker_title;


/* Which user flagged the most distinct videos that ended up approved by YouTube? 
Output, in one column, their full name or names in case of a tie. 
In the user's full name, include a space between the first and the last name.
*/
with temp as (
	select user_firstname + ' ' + user_lastname as fullname, count(distinct video_id) as total_approved_videos,
		dense_rank() over (order by count(distinct video_id) desc) as user_rank
	from user_flags u
	join flag_review v on u.flag_id = v.flag_id
	where reviewed_outcome in ('approved')
	group by fullname
)
select fullname
from temp
where user_rank = 1;


/*
Eligible Employees
IBM wants to reward employees who meet certain criteria. However, to ensure fairness, the following conditions must be met:
•	The employee must have been with the company for at least 3 years
•	The employee's department must have at least 5 employees
•	The salary must be within the top 10% of salaries within the department
The output should include the Employee ID, Salary, and Department of the employees meeting the criteria.
*/
--select * from employee_salaries
select Employee_ID, Salary, Department 
from employee_salaries
where tenure >= 3 and 
      department in (select department from employee_salaries group by department having count(employee_id) >= 5) and
      salary in (select distinct top 10 percent salary from employee_salaries order by salary desc);


/*
Users By Average Session Time
Calculate each user's average session time. 
A session is defined as the time difference between a page_load and page_exit. 
For simplicity, assume a user has only 1 session per day and if there are multiple of the same events on that day, 
    consider only the latest page_load and earliest page_exit, 
    with an obvious restriction that load time event should happen before exit time event . 
Output the user_id and their average session time.
*/
with CTE as (
 SELECT t1.user_id, 
        t1.timestamp::date as date,
        min(t2.timestamp::TIMESTAMP) - max(t1.timestamp::TIMESTAMP)               
        as session_duration
 FROM facebook_web_log t1
   JOIN facebook_web_log t2 
   ON t1.user_id = t2.user_id
 WHERE t1.action = 'page_load'
   AND t2.action = 'page_exit' 
   AND t2.timestamp > t1.timestamp
 GROUP BY 1, 2)
SELECT user_id, avg(session_duration) FROM CTE
GROUP BY user_id;


/*
Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. 
The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their activity rank. 
Order records by the total emails in descending order. Sort users with the same number of emails in alphabetical order.
In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails. 
    For tie breaker use alphabetical order of the user usernames.
*/
select from_user, (count(to_user)) as num_emails,
    dense_rank() over (order by count(to_user) desc) as rank
from google_gmail_emails
group by from_user
order by num_emails desc, from_user asc;


/*
Write a query that'll identify returning active users. 
A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. 
Output a list of user_ids of these returning active users.
*/
-- select * from amazon_transactions;
select user_id, count(*) as visits
from amazon_transactions
group by user_id
having count(*) > 1;

-- Using Self Join
select a1.user_id as user_id, a1.created_at as first_date, a2.created_at as subsequent_dates 
from amazon_transactions a1 
inner join amazon_transactions a2 on a1.user_id = a2.user_id and a1.id != a2.id 
order by a1. user_id, a1.created_at;

select distinct(a1.user_id) as user_id
from amazon_transactions a1 
inner join amazon_transactions a2 
	on a1.user_id = a2.user_id and a1.id != a2.id 
where  a1.created_at - a2.created_at between 0 and 7 
order by a1.user_id;


--------------------------------------------------------------------------------------------------------
-- https://datalemur.com/blog/Boeing-SQL-Interview-Questions
--------------------------------------------------------------------------------------------------------


/*
Teams Power Users [Microsoft SQL Interview Question]
Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. 
Display the IDs of these 2 users along with the total number of messages they sent. 
Output the results in descending order based on the count of the messages.
No two users have sent the same number of messages in August 2022.
*/
select top 2 sender_id, count(message_id) as message_cnt
from messages
where extract(year from sent_date) = '2022' and 
      extract(month from sent_date) = '8'
group by sender_id
order by message_cnt desc;


/*
Defining Power Customers for Boeing
Boeing would like to consider their power customers as those companies or airlines who purchase more than average number of aircraft within a year. 
The question is to identify these companies from Boeing's sales database. 
You are given a table sales, which records all sales transactions.
Write a SQL query to identify these power customers on a yearly basis, given a cut-off sale count (for example, 10 purchases per year).
*/
select customer_id, count(aircraft_id) as total_sales, year(sale_date) as year
from sales
group by customer_id, year(sale_date)
having total_sales > 10;


/*
Supercloud Customer
Azure Supercloud customer is defined as a company that purchaes at least one product from each product category.
Write a query that effectively identifies the common ID of such Supercloud customers
*/
select c.customer_id, count(distinct p.product_category) as unique_cnt
from customer_contracts as c
left join products p on c.customer_id = p.customer_id
group by c.customer_id;
 

/*
Aircraft Utilization Rate
At Boeing, one important metric is the utilization rate of each aircraft model, which is the ratio of total flight hours to total hours available for each aircraft. 
Let's assume you have access to the flights and aircrafts tables in the Boeing database.
The question is: Write a SQL query to calculate the utilization rate of each aircraft for every day. 
The utilization rate is defined as the total flight hours divided by the total hours available for each aircraft.
The flights table tracks each flight's departure time, arrival time, and aircraft ID associated with that flight.
The aircrafts table stores the aircraft ID and the total hours that aircraft is available for a flight each day.
*/
select a.aircraft_id, date(a.departure_time) as date, 
    sum(datediff(hour, f.departure_time, f.arrival_time)) / a.availability_hours_per_day as utilization_rate
from flights f
join aircrafts a on f.aircraft_id=a.aircraft_id
group by date, aircraft_id;


/*
Highest-Grossing Items
Assume you're given a table containing data on Amazon customers and their spending on products in different category.
Write a query to identify the top two highest-grossing products within each category in the year 2022. 
The output should include the category, product, and total spend.
*/
-- category, product, and total spend
with sale_items as (
  select category, product, sum(spend) as total_spent, 
          rank() over (partition by category order by sum(spend) desc) as ranking
  from product_spend 
  where extract(year from transaction_date)='2022'
  group by category, product
)
select category, product, total_spent
from sale_items
where ranking <= 2
order by total_spent desc;


/*
Sending vs. Opening Snaps
Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.
Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group.
Round the percentage to 2 decimal places in the output.
*/
SELECT age.age_bucket, 
  ROUND(SUM(CASE WHEN activity_type = 'send' THEN time_spent END)/SUM(time_spent)*100, 2) AS send_perc,
  ROUND(SUM(CASE WHEN activity_type = 'open' THEN time_spent END)/SUM(time_spent)*100, 2) AS open_perc
FROM activities act
INNER JOIN age_breakdown age
  ON act.user_id = age.user_id
WHERE activity_type IN ('send','open')
GROUP BY age.age_bucket;

SELECT 
  age.age_bucket, 
  ROUND(100.0 * 
    SUM(time_spent) FILTER (WHERE activity_type = 'send')/
      SUM(time_spent),2) AS send_perc, 
  ROUND(100.0 * 
    SUM(activities.time_spent) FILTER (WHERE activity_type = 'open')/
      SUM(activities.time_spent),2) AS open_perc
FROM activities 
INNER JOIN age_breakdown AS age 
  ON activities.user_id = age.user_id 
WHERE activities.activity_type IN ('send', 'open') 
GROUP BY age.age_bucket;


/*
User's Third Transaction
Assume you are given the table below on Uber transactions made by users. 
Write a query to obtain the third transaction of every user. 
Output the user id, spend and transaction date.
*/
WITH trans_num AS (
  SELECT user_id, spend, transaction_date,
    ROW_NUMBER() over (PARTITION BY user_id ORDER BY transaction_date) AS transaction_num
  FROM transactions
) 
SELECT user_id, spend, transaction_date
FROM trans_num
WHERE transaction_num = 3;

SELECT user_id, spend, transaction_date
FROM (
	SELECT user_id, spend, transaction_date,
    ROW_NUMBER() over (PARTITION BY user_id ORDER BY transaction_date) AS row_num
	FROM transactions
		) AS trans_num
WHERE row_num = 3;


/*
Monthly Number of Aerospace Products Manufactured
Using the products and manufacturing_plants tables, 
create an SQL query that provides the total number of each product manufactured at each plant, month by month, 
along with comparisons to the same month in the previous year.
*/
WITH plants AS (
	SELECT manufacturing_plant AS plant, product_id, manufacture_date
		EXTRACT(YEAR FROM manufacture_date) AS year,
		EXTRACT(MONTH FROM manufacture_date) as month
	FROM products
)
SELECT plant, COUNT(product_id), SUM(quantity),
	LAG(SUM(quantity), 1) OVER (PARTITION BY manufacturing_plant, product_id 
								ORDER BY year) AS quantity_last_year
FROM plants
GROUP BY product_id, plant, year, month
ORDER BY year, month, product_id, plant;


/*
Top 5 Artists
Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. 
Display the top 5 artist names in ascending order, along with their song appearance ranking.
*/
WITH top10_rank_artists AS (
  SELECT artists.artist_name, COUNT(songs.song_id) AS songs_cnt, 
    DENSE_RANK() OVER (ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  JOIN songs 
    ON songs.artist_id = artists.artist_id
  JOIN global_song_rank ranking
    ON ranking.song_id = songs.song_id
  WHERE ranking.rank <= 10
  GROUP BY artists.artist_name
)
SELECT artist_name, artist_rank
FROM top10_rank_artists
WHERE artist_rank <= 5;


/*
What are some ways you can identify duplicates in a table?
*/
SELECT user_id, COUNT(*) AS cnt
FROM table
GROUP BY user_id
WHERE cnt > 1;


/*
What is database normalization?
	to break table into smaller specific tables to avoid duplicates
	use foreign key to link with the main table
Data normalization removes redundancy from a database and introduces non-redundant, standardized data. 
On the other hand, Denormalization is a process used to combine data from multiple tables into a single table 
	that can be queried faster.
*/


/*
Relational database:
	data stored in tables
	each table in a schema
	at least one primary key, so no duplicated rows in database
In SQL, requires structure and format.

Non-relational database
	schema-less, so records with different schemas, nested structure
In NoSQL, collection of related records can be stores on a node.
*/


/*
Speeding Up SQL Queries
	The greater the number of joins, the higher the complexity and the larger the number of traversals in tables.
	Speed is also affected by whether or not there are indices present in the database. 
	Indices are extremely important and allow you to quickly search through a table and find a match for some column specified in the query.
*/

/*
Product Performance Analysis
Design a SQL query to find the cumulative monthly sales quantity for each product from the sales table, sorted by the product and the month.
Please consider the launch date in the products table. Only include sales that occurred after the launch date of the product.
*/
SELECT p.product_id, p.product_name, EXTRACT(MONTH FROM s.sale_date) AS month, SUM(s.quantity)
	SUM(s.quantity) OVER (PARTITION BY p.product_id ORDER BY EXTRACT(MONTH FROM s.sale_date)) AS cumsum
FROM products AS p
JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_date >= p.launch_date 
GROUP BY p.product_id, p.product_name, EXTRACT(MONTH FROM s.sale_date)
ORDER BY p.product_id, month

WITH monthly_sales AS (
    SELECT product_id, 
           EXTRACT(MONTH FROM sale_date) as month, 
           SUM(quantity) as monthly_qty 
    FROM sales 
    GROUP BY product_id, month
),
products_with_sales AS (
    SELECT p.product_name, 
           ms.month, 
           ms.monthly_qty
    FROM products p
    JOIN monthly_sales ms 
      ON p.product_id = ms.product_id
    WHERE ms.month >= p.launch_date
)
SELECT ps.product_name, 
       ps.month, 
       SUM(ps.monthly_qty) OVER (PARTITION BY ps.product_name ORDER BY ps.month) as cumulative_qty 
FROM products_with_sales ps 
ORDER BY ps.product_name, ps.month;


/*
Card Launch Success 
JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.
Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. 
The launch month is the earliest record in the monthly_cards_issued table for a given card. 
Order the results starting from the biggest issued amount.
*/
WITH issued_order AS (
  SELECT card_name, RANK() OVER (PARTITION BY card_name ORDER BY issue_month, issue_year) AS rank, issued_amount
  FROM monthly_cards_issued
)
SELECT card_name, issued_amount
FROM issued_order
WHERE rank = 1
ORDER BY issued_amount DESC;


/*
Military Equipment Maintenance Scheduling
Given a database that includes two tables - equipment and maintenance, 
the company wants to have a report that shows all the equipment that were maintained in the last month and the average duration of maintenance.
*/
SELECT e.equipment_name, AVG(DATEDIFF(m.start_date, m.end_date)) AS avg_maintainence_days
FROM equipment e
JOIN maintainence m
	ON e.maintenance_id = m.maintenance_id
GROUP BY e.equipment_name;

SELECT e.equipment_name, AVG(DATEDIFF(m.start_date, m2.end_date)) AS avg_maintainence_days
FROM equipment e
JOIN maintainence m
	ON e.equipment_id  = m.equipment_id 
JOIN maintainence m2
	ON e.equipment_id  = m2.equipment_id 
WHERE EXTRACT(MONTH FROM m2.start_date) > EXTRACT(MONTH FROM m.start_date) AND 
	 EXTRACT(YEAR FROM m2.start_date) = EXTRACT(YEAR FROM m.start_date)
GROUP BY e.equipment_name


/*
Given the total number of messages sent between two users by date on messenger.
Write a query to get the distribution of the number of conversations created by each user by day in the year 2020.
*/
WITH user1_daily_messages AS (
	SELECT user1, date, COUNT(DISTINCT user2) AS num_conversations
	FROM messages
	WHERE YEAR(date) = '2022'
	GROUP BY user1, date
)
SELECT num_conversations, COUNT(*) AS frequency
FROM user1_daily_messages
GROUP BY num_conversations;


/*
Given a users table, write a query to get the cumulative number of new users added by day, with the total reset every month.
*/
WITH daily_total AS (
    SELECT DATE(created_at) AS dt, COUNT(*) AS cnt
    FROM users
    GROUP BY dt
) 
SELECT t.dt AS date, SUM(u.cnt) AS monthly_cumulative
FROM daily_total AS t
LEFT JOIN daily_total AS u
    ON t.dt >= u.dt
    AND MONTH(t.dt) = MONTH(u.dt)
    AND YEAR(t.dt) = YEAR(u.dt)
GROUP BY date


/*
Write a query to return pairs of projects where the end date of one project matches the start date of another project. 
*/
select p1.title as project_title_start, p2.title as project_title_end, p1.start_date as date
from projects p1
join projects p2 
    on p1.start_date = p2.end_date;


/*
Customer Orders
Write a query to identify customers who placed more than three transactions each in both 2019 and 2020.
*/
WITH transactions_yearly AS (
    select u.name as customer_name, 
        sum(case when year(t.created_at) = '2019' then 1 else 0 end) as t_2019,
        sum(case when year(t.created_at) = '2020' then 1 else 0 end) as t_2020
    from users u
    join transactions t
        on u.id = t.user_id
    group by u.id
)
SELECT customer_name
FROM transactions_yearly
WHERE t_2019 >= 3 and t_2020 >= 3;


/*
Employee Salaries
Given a employees and departments table, select the top 3 departments with at least ten employees 
and rank them according to the percentage of their employees making over 100K in salary.
*/
select d.name as department_name, count(*) as number_of_employees,
    sum(case when e.salary>100000 then 1 else 0 end)/count(*) as percentage_over_100k
from departments d
join employees e
on d.id = e.department_id
group by d.name
having number_of_employees >= 10


/*
SQL Joins
*/
SELECT columns FROM Tab1 
	LEFT JOIN Tab2 ON Tab1.key = Tab2.key   --left exclusive
	WHERE Tab2.key IS NULL;
SELECT columns FROM Tab1 
	FULL OUTER JOIN Tab2 ON Tab1.key = Tab2.key  --excluding inner
	WHERE Tab1.key IS NULL OR Tab2.key IS NULL;


-- -- Amazon DE

-- List the number of orders, customers, and the total order cost for each city. 
-- Include only those cities where at least five orders have been placed but count all the customers in these cities even if they did not place any orders.
/*
Merge the two tables
Aggregate the number of orders, total order value, and the number of customers for each city.
Subset only those cities that have five or more orders.
*/
SELECT 
    customers.city
    , COUNT(orders.id) AS orders_per_city
    , COUNT(DISTINCT customers.id) AS customers_per_city
    , SUM(orders.total_order_cost) AS orders_cost_per_city
FROM 
    customers 
    LEFT JOIN orders 
        ON customers.id = orders.cust_id
GROUP BY 1
HAVING COUNT(orders.id) >=5;


-- Find the name of the manager from the largest department. Output their first and last names.
/*
Find the number of employees in each department
Output the manager from the department(s) with the maximum number of employees
*/
WITH dept_emp AS (
SELECT 
    *
    , COUNT(*) OVER (PARTITION BY department_id) as num_employees
FROM az_employees
)
SELECT
     first_name, last_name, num_employees
FROM dept_emp
WHERE num_employees = (SELECT MAX(num_employees) FROM dept_emp)
AND UPPER(position) LIKE '%MANAGER%';


/*
Find the products that are exclusive only to Amazon and not available at TopShop or Macys. 
A product is exclusive if the combination of product name and maximum retail price is not available in the other stores. 
Output the product name, brand name, price, and rating for all exclusive products.
*/
SELECT
    a.product_name
    , a.brand_name
    , a.price
    , a.rating
FROM innerwear_amazon_com AS a
LEFT JOIN innerwear_topshop_com AS t
    ON a.product_name = t.product_name
    AND a.mrp = t.mrp
LEFT JOIN innerwear_macys_com AS m
    ON a.product_name = m.product_name
    AND a.mrp = m.mrp    
WHERE 
    t.mrp IS NULL
    AND t.product_name IS NULL
    AND m.mrp IS NULL
    AND m.product_name IS NULL    ;

SELECT 
    product_name
    , brand_name
    , price
    , rating
FROM innerwear_amazon_com AS a
WHERE (product_name, mrp) NOT IN (
    SELECT product_name, mrp FROM 
    (
        SELECT DISTINCT product_name, mrp FROM innerwear_macys_com
        UNION
        SELECT DISTINCT product_name, mrp FROM innerwear_topshop_com
        ) q
    );


/*
Complex query, longer runtime
*/
-- land with above average sale_price 
SELECT SH.Map_Parcel, SH.Deed_Type, AVG(Sale_Price_Avg) AS Sale_Price_Avg
FROM dbo.[Sales History] SH
INNER JOIN dbo.[Previous Appraisals] PA ON SH.Map_Parcel = PA.Map_Parcel
INNER JOIN (SELECT Map_Parcel, Deed_Type, AVG(CAST(REPLACE(REPLACE(Sale_Price, ',',''),'$','') AS bigint)) AS Sale_Price_Avg
			FROM dbo.[Sales History]
			WHERE Deed_Type IS NOT NULL
			GROUP BY Deed_Type, Map_Parcel) AS SH_Avg ON SH.Map_Parcel = SH_Avg.Map_Parcel
WHERE Sale_Price_Avg > CAST(REPLACE(REPLACE(Sale_Price, ',',''),'$','') AS bigint)
GROUP BY SH.Map_Parcel, SH.Deed_Type;


/*
Average Number of Projects Handled Per Engineer at Northrop Grumman
Pertinent question could be to find the average number of projects handled by an engineer. 
This could help analyze workload distribution and resource management.
*/
SELECT 
    e.engineer_id,
    AVG(p.num_projects) as average_num_projects
FROM Engineers e
LEFT JOIN
   (SELECT 
    engineer_id,
    COUNT(project_id) as num_projects
    FROM Projects
    GROUP BY engineer_id) p
ON e.engineer_id = p.engineer_id
GROUP BY e.engineer_id;


/*
https://en.wikibooks.org/wiki/SQL_Exercises/The_Hospital
*/

-- Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.

SELECT Name 
  FROM Physician 
 WHERE EmployeeID IN 
       (
         SELECT Physician FROM Undergoes U WHERE NOT EXISTS 
            (
               SELECT * FROM Trained_In 
                WHERE Treatment = Procedure 
                  AND Physician = U.Physician
            )
       );

SELECT P.Name FROM 
 Physician AS P, 
 (SELECT Physician, Procedure FROM Undergoes 
    EXCEPT 
    SELECT Physician, Treatment FROM Trained_in) AS Pe
 WHERE P.EmployeeID=Pe.Physician];

 SELECT Name 
  FROM Physician
 WHERE EmployeeID IN
   (
      SELECT Undergoes.Physician
        FROM Undergoes 
             LEFT JOIN Trained_In
             ON Undergoes.Physician=Trained_In.Physician
                 AND Undergoes.Procedures=Trained_In.Treatment
       WHERE Treatment IS NULL
   );

-- Same as the previous query, but include the following information in the results: 
-- Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.

SELECT P.Name AS Physician, Pr.Name AS Procedure, U.Date, Pt.Name AS Patient 
  FROM Physician P, Undergoes U, Patient Pt, Procedure Pr
  WHERE U.Patient = Pt.SSN
    AND U.Procedure = Pr.Code
    AND U.Physician = P.EmployeeID
    AND NOT EXISTS 
              (
                SELECT * FROM Trained_In T
                WHERE T.Treatment = U.Procedure 
                AND T.Physician = U.Physician
              );

-- Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, 
-- but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).

SELECT Name 
  FROM Physician 
 WHERE EmployeeID IN 
       (
         SELECT Physician FROM Undergoes U 
          WHERE Date > 
               (
                  SELECT CertificationExpires 
                    FROM Trained_In T 
                   WHERE T.Physician = U.Physician 
                     AND T.Treatment = U.Procedure
               )
       );

SELECT P.Name FROM 
 Physician AS P,    
 Trained_In T,
 Undergoes AS U
 WHERE T.Physician=U.Physician AND T.Treatment=U.Procedure AND U.Date>T.CertificationExpires AND P.EmployeeID=U.Physician

/*
Using a scalar-valued user-defined function that calculates the ISO week
*/
CREATE FUNCTION dbo.ISOweek (@DATE datetime)
RETURNS int
WITH EXECUTE AS CALLER
AS
BEGIN
    DECLARE @ISOweek int;
    SET @ISOweek= DATEPART(wk,@DATE)+1
        -DATEPART(wk,CAST(DATEPART(yy,@DATE) as CHAR(4))+'0104');
--Special cases: Jan 1-3 may belong to the previous year
    IF (@ISOweek=0)
        SET @ISOweek=dbo.ISOweek(CAST(DATEPART(yy,@DATE)-1
            AS CHAR(4))+'12'+ CAST(24+DATEPART(DAY,@DATE) AS CHAR(2)))+1;
--Special case: Dec 29-31 may belong to the next year
    IF ((DATEPART(mm,@DATE)=12) AND
        ((DATEPART(dd,@DATE)-DATEPART(dw,@DATE))>= 28))
    SET @ISOweek=1;
    RETURN(@ISOweek);
END;
GO
SET DATEFIRST 1;
SELECT dbo.ISOweek(CONVERT(DATETIME,'12/26/2004',101)) AS 'ISO Week';

/*
A stored procedure is used to retrieve data, modify data, and delete data in database table.
*/
CREATE PROCEDURE Map_Parcel_selected   --retrieve table for map_parcel
	@Map_Parcel VARCHAR(20)
AS
BEGIN
	SELECT Map_Parcel, Mailing_Address, ISNULL(Number_of_Rooms,0) AS Number_of_Rooms
	FROM dbo.[Property Summary]
	WHERE Map_Parcel = @Map_Parcel 
END;

EXEC Map_Parcel_selected @Map_Parcel = '001 00 0 001.00' ;

create procedure spCreateNewFarmer
	@first_name varchar(3),			-- 3 instead of 30 error
	@last_name varchar(3)
as
begin
	insert into Farmer (first_name, last_name) values (@first_name, @last_name)
	insert into Audit_Log (audit_message) values ('Created user for ' + @first_name + ' ' + @last_name)
end
execute spCreateNewFarmer @first_name = 'Ankur', @last_name='Patel';

/*
DDL data definition language
*/
CREATE DATABASE/TABLE/VIEW;
CREATE INDEX index_name ON table_name (column1, column2, ...);
CREATE OR REPLACE VIEW view_name AS SELECT column1, column2, ... 
									FROM table_name WHERE condition;  -- database objects, not dropped when disconnect
DROP DATABASE/TABLE/VIEW/COLUMN/CONSTRAINT/INDEX name;
TRUNCATE TABLE table_name; -- deletes data
BACKUP DATABASE testDB TO DISK = 'D:\backups\testDB.bak';
ALTER TABLE Persons ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName)
					ADD CONSTRAINT CHK_PersonAge CHECK (Age>=18 AND City='NYC')  -- DROP CONSTRAINT CHK_PersonAge;
ALTER TABLE table_name RENAME COLUMN old_name TO new_name;  -- mysql
ALTER TABLE table_name MODIFY COLUMN column_name datatype;
/*
DML data manipulation language
*/
DELETE FROM table_name WHERE condition;
UPDATE table name SET <attribute> = <expression> WHERE <condition>;
/*
DCL/TCL data/transaction control language
*/
GRANT select, update ON TestTable TO user1, user2;  
REVOKE select, update ON TestTable TO user1, user2;  
BEGIN TRANSACTION 
   INSERT INTO TestTable( ID, Value ) VALUES  ( 1, N'10')
   -- this will create a savepoint after the first INSERT
   SAVE TRANSACTION FirstInsert
   INSERT INTO TestTable( ID, Value ) VALUES  ( 2, N'20')
   -- this will rollback to the savepoint right after the first INSERT was done
   ROLLBACK TRANSACTION FirstInsert
-- this will commit the transaction leaving just the first INSERT 
COMMIT
SELECT * FROM TestTable;
/*
Copy table
can export database
*/
COPY table_name (column1, column2, ...) FROM 'data_file' WITH (FORMAT csv);
COPY persons(first_name,last_name,email) TO 'C:\tmp\persons_partial_db.csv' DELIMITER ',' CSV HEADER;







