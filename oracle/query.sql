---------- SQL Query Interview Questions ----------
---------------------------------------------------

SELECT * FROM employees;
SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES ;
SELECT FIRST_NAME “EMPLOYEE NAME” FROM EMPLOYEES;
SELECT UPPER (FIRST_NAME) FROM EMPLOYEES;
SELECT LOWER (FIRST_NAME) FROM EMPLOYEE;
SELECT DISTINCT DEPARTMENT FROM EMPLOYEE;
SELECT SUBSTR (FIRST_NAME, 0, 3) FROM EMPLOYEE;
SELECT INSTR (FIRST_NAME,'o') FROM EMPLOYEE WHERE FIRST_NAME='John';
SELECT RTRIM (FIRST_NAME) FROM EMPLOYEES;
SELECT LENGTH (FIRST_NAME) FROM EMPLOYEE;
SELECT FIRST_NAME, REPLACE (FIRST_NAME,'o','$') FROM EMPLOYEES;
SELECT FIRST_NAME|| '_' ||LAST_NAME FROM EMPLOYEE;
SELECT FIRST_NAME, 
	TO_CHAR(JOINING_DATE,'YYYY') JOINYEAR ,
	 TO_CHAR(JOINING_DATE,'MON'),
	  TO_CHAR(JOINING_DATE,'DD')          FROM         EMPLOYEE;
SELECT * FROM EMPLOYEE ORDER BY FIRST_NAME ASC
SELECT * FROM EMPLOYEE ORDER BY FIRST_NAME DESC;
SELECT * FROM EMPLOYEE ORDER BY FIRST_NAME ASC, SALARY DESC;
SELECT * FROM EMPLOYEE WHERE FIRST_NAME='John';
SELECT * FROM EMPLOYEE WHERE FIRST_NAME IN ('John', 'Roy');
SELECT * FROM EMPLOYEE WHERE FIRST_NAME NOT IN ('JOHN', 'ROY');
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE 'J%';
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE '%o%';
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE '%n';
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE '___n'; (Underscores)
SELECT * FROM EMPLOYEE WHERE FIRST_NAME LIKE 'J___'; (Underscores)
SELECT * FROM EMPLOYEE WHERE SALARY >600000;
SELECT * FROM EMPLOYEE WHERE SALARY <800000;
SELECT * FROM EMPLOYEE WHERE SALARY BETWEEN 500000 AND 800000;
SELECT * FROM EMPLOYEE
 WHERE TO_CHAR (JOINING_DATE, 'YYYY')='2013';
SELECT * FROM EMPLOYEE WHERE TO_CHAR(JOINING_DATE,'MM')='01' 
SELECT * FROM EMPLOYEE WHERE TO_CHAR(JOINING_DATE,'MON')='JAN';
SELECT * FROM EMPLOYEES WHERE JOINING_DATE <TO_DATE('01/01/2013','DD/MM/YYYY');
SELECT SYSDATE FROM DUAL;
Select FIRST_NAME FROM EMPLOYEES WHERE LAST_NAME LIKE '%\%%';
Select           translate(LAST_NAME,'%','        ')        from          employees;
SELECT DEPARTMENT,SUM(SALARY) TOTAL_SALARY FROM EMPLOYEE GROUP BY DEPARTMENT;
SELECT DEPARTMENT, SUM (SALARY) TOTAL_SALARY
 FROM EMPLOYEE GROUP BY DEPARTMENT
ORDER BY TOTAL_SALARY DESC;
SELECT DEPARTMENT,COUNT(FIRST_NAME),SUM(SALARY) TOTAL_SALARY
 FROM EMPLOYEE GROUP BY DEPARTMENT ORDER BY TOTAL_SALARY DESC;
SELECT DEPARTMENT,AVG(SALARY) AVGSALARY
 FROM EMPLOYEE GROUP BY DEPARTMENT ORDER BY AVGSALARY ASC;
SELECT DEPARTMENT,MAX(SALARY) MAXSALARY
 FROM EMPLOYEE GROUP BY DEPARTMENT ORDER BY MAXSALARY ASC;
SELECT DEPARTMENT,MIN(SALARY) MINSALARY
 FROM EMPLOYEE GROUP BY DEPARTMENT ORDER BY MINSALARY ASC;
SELECT DEPARTMENT_ID,SUM(SALARY) TOTAL_SALARY
 FROM EMPLOYEES GROUP BY DEPARTMENT_ID
 HAVING SUM(SALARY) >800000 ORDER BY TOTAL_SALARY DESC;
---------------
-- 2.1 Select the last name of all employees.
select LastName from Employees;


-- 2.2 Select the last name of all employees, without duplicates.
select distinct LastName from employees;


-- 2.3 Select all the data of employees whose last name is "Smith".
select * from employees where lastname = 'Smith';


-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
select * from Employees where lastname in ('Smith', 'Doe');
select * from Employees where lastname = 'Smith' or lastname = 'Doe';


-- 2.5 Select all the data of employees that work in department 14.
select * from Employees where department = 14;

-- 2.6 Select all the data of employees that work in department 37 or department 77.
select * from employees where department = 37 or department = 77;
select * from employees where department in (37, 77);


-- 2.7 Select all the data of employees whose last name begins with an "S".
select * from employees where LastName like 'S%';


-- 2.8 Select the sum of all the departments' budgets.
select sum(budget) from Departments;

select Name, sum(Budget) from Departments group by Name;


-- 2.9 Select the number of employees in each department (you only need to show the department code and the number of employees).
select Department, count(*) from employees group by department;

SELECT Department, COUNT(*)
  FROM Employees
  GROUP BY Department;


-- 2.10 Select all the data of employees, including each employee's department's data.
select a.*, b.* from employees a join departments b on a.department = b.code;

SELECT SSN, E.Name AS Name_E, LastName, D.Name AS Name_D, Department, Code, Budget
 FROM Employees E INNER JOIN Departments D
 ON E.Department = D.Code;


-- 2.11 Select the name and last name of each employee, along with the name and budget of the employee's department.
select a.name, a.lastname, b.name Department_name, b.Budget
from employees a join departments b
on a.department = b.code;

/* Without labels */
SELECT Employees.Name, LastName, Departments.Name AS DepartmentsName, Budget
  FROM Employees INNER JOIN Departments
  ON Employees.Department = Departments.Code;

/* With labels */
SELECT E.Name, LastName, D.Name AS DepartmentsName, Budget
  FROM Employees E INNER JOIN Departments D
  ON E.Department = D.Code;


-- 2.12 Select the name and last name of employees working for departments with a budget greater than $60,000.
select name, lastname
from employees 
where department in (
select code from departments where Budget>60000
);

/* Without subquery */
SELECT Employees.Name, LastName
  FROM Employees INNER JOIN Departments
  ON Employees.Department = Departments.Code
    AND Departments.Budget > 60000;

/* With subquery */
SELECT Name, LastName FROM Employees
  WHERE Department IN
  (SELECT Code FROM Departments WHERE Budget > 60000);


-- 2.13 Select the departments with a budget larger than the average budget of all the departments.
select *
from departments 
where budget > (
select avg(budget) from departments
);

SELECT *
  FROM Departments
  WHERE Budget >
  (
    SELECT AVG(Budget)
    FROM Departments
  );


-- 2.14 
-- Select the names of departments with more than two employees.
select b.name 
from departments b
where code in (
select department
from employees
group by department
having count(*)>2
);

/* With subquery */
SELECT Name FROM Departments
  WHERE Code IN
  (
    SELECT Department
      FROM Employees
      GROUP BY Department
      HAVING COUNT(*) > 2
  );

/* With UNION. This assumes that no two departments have
   the same name */
SELECT Departments.Name
  FROM Employees INNER JOIN Departments
  ON Department = Code
  GROUP BY Departments.Name
  HAVING COUNT(*) > 2;


-- 2.15
-- Very Important
-- Select the name and last name of employees working for departments with second lowest budget.

select name, lastname
from employees
where department =(
select temp.code 
from (select * from departments order by budget limit 2) temp
order by temp.budget desc limit 1
);


/* With subquery */
SELECT e.Name, e.LastName
FROM Employees e 
WHERE e.Department = (
       SELECT sub.Code 
       FROM (SELECT * FROM Departments d ORDER BY d.budget LIMIT 2) sub 
       ORDER BY budget DESC LIMIT 1);
       

-- 2.16
-- Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11. 
-- Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.
insert into departments values(11, 'Quality Assurance', 40000);
insert into employees values(847219811, 'Mary', 'Moore', 11);


-- 2.17
-- Reduce the budget of all departments by 10%.
update departments 
set budget = 0.9 * budget;


-- 2.18
-- Reassign all employees from the Research department (code 77) to the IT department (code 14).
update employees
set department = 14
where department = 77;

-- 2.19
-- Delete from the table all employees in the IT department (code 14).

delete from employees
where department = 14;

-- 2.20
-- Delete from the table all employees who work in departments with a budget greater than or equal to $60,000.
delete from employees
where department in (
select code 
from departments
where budget>=60000
);


-- 2.21
-- Delete from the table all employees.
delete from employees;

SELECT * FROM EMPLOYEES;



---------------------------------------------------
SELECT * FROM countries;




---------------------------------------------------
SELECT * FROM departments;




---------------------------------------------------
SELECT * FROM job_history;




---------------------------------------------------
SELECT * FROM jobs;

SELECT job_title, min_salary FROM jobs;

SELECT job_title AS Title,
min_salary AS "Minimum Salary" FROM jobs;

SELECT DISTINCT department_id FROM
employees;

SELECT DISTINCT department_id, job_id
FROM employees;

-- The DUAL table
SELECT * FROM dual;
SELECT SYSDATE, USER FROM dual;
SELECT 'I''m ' || user || ' Today is ' || SYSDATE FROM DUAL;

-- ***Limiting rows***
--Employees who work for dept 90
SELECT first_name || ' ' || last_name "Name",
department_id FROM employees
WHERE department_id = 90;

-- Comparison operators
-- !=, <>, ^= (Inequality)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct != .35;

-- < (Less than)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct < .15;

-- > (Greater than)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct != .35;

-- <= (Less than or equal to)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct <= .15;

-- >= (Greater than or equal to)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct >= .35;

-- ANY or SOME
SELECT first_name || ' ' || last_name "Name",
department_id FROM employees
WHERE department_id <= ANY (10, 15, 20, 25);

-- ALL
SELECT first_name || ' ' || last_name "Name",
department_id FROM employees
WHERE department_id >= ALL (80, 90, 100);

-- *For all the comparison operators discussed, if one side of the operator is NULL, the result is NULL.

-- NOT
SELECT first_name, department_id
FROM employees
WHERE not (department_id >= 30);

-- AND
SELECT first_name, salary
FROM employees
WHERE last_name = 'Smith'
AND salary > 7500;

-- OR
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Kelly'
OR last_name = 'Smith';

-- *When a logical operator is applied to NULL, the result is UNKNOWN. UNKNOWN acts similarly to FALSE; the only difference is that NOT FALSE is TRUE, whereas NOT UNKNOWN is also UNKNOWN.

-- Other operators

-- IN and NOT IN
-- IN is equivalent to =ANY
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN (10, 20, 90);

--NOT IN is equivalent to !=ALL
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id NOT IN
(10, 30, 40, 50, 60, 80, 90, 110, 100);

-- *When using the NOT IN operator, if any value in the list or the result returned from the subquery is NULL, the NOT IN condition is evaluated to FALSE.

-- BETWEEN (is inclusive)
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 5000 AND 6000;

-- EXISTS
-- The EXISTS operator is always followed by a subquery in parentheses. EXISTS evaluates to
-- TRUE if the subquery returns at least one row. The following example lists the employees
-- who work for the administration department.
SELECT last_name, first_name, department_id
FROM employees e
WHERE EXISTS (select 1 FROM departments d
				WHERE d.department_id = e.department_id
				AND d.department_name = 'Administration');

-- IS NULL and IS NOT NULL
-- The = or != operator will not work with NULL values.

-- employees who do not have a department assigned
SELECT last_name, department_id
FROM employees
WHERE department_id IS NULL;

-- This doesn't work correctly
SELECT last_name, department_id
FROM employees
WHERE department_id = NULL;

-- LIKE
SELECT first_name, last_name
FROM employees
WHERE first_name LIKE 'Su%'
AND last_name NOT LIKE 'S%';

-- Escaping the _ character
SELECT job_id, job_title
FROM jobs
WHERE job_id like 'AC\_%' ESCAPE '\';  --'

-- ***Sorting rows

-- ASC is the default sorting
SELECT first_name || ' ' || last_name "Employee Name"
FROM employees
WHERE department_id = 90
ORDER BY last_name;

-- Multiple column sorting
SELECT first_name, hire_date, salary, manager_id mid
FROM employees
WHERE department_id IN (110,100)
ORDER BY mid ASC, salary DESC, hire_date;

-- *You can use column alias names in the ORDER BY clause.

-- If the DISTINCT keyword is used in the SELECT clause, you can use only those columns
-- listed in the SELECT clause in the ORDER BY clause. If you have used any operators on columns in
-- the SELECT clause, the ORDER BY clause also should use them.

-- Incorrect
SELECT DISTINCT 'Region ' || region_id
FROM countries
ORDER BY region_id;

-- Correct
SELECT DISTINCT 'Region ' || region_id
FROM countries
ORDER BY 'Region ' || region_id;

-- Sorting by column number
SELECT first_name, hire_date, salary, manager_id mid
FROM employees
WHERE department_id IN (110,100)
ORDER BY 4, 2, 3;

-- *The ORDER BY clause cannot have more than 255 columns or expressions.

-- ***Sorting NULLs
--By default, in an ascending-order sort, the NULL values appear at the bottom of the result set;
--that is, NULLs are sorted higher.

-- Nulls are sorted higher
SELECT last_name, commission_pct
FROM employees
WHERE last_name LIKE 'R%'
ORDER BY commission_pct ASC, last_name DESC;

-- Null first
SELECT last_name, commission_pct
FROM employees
WHERE last_name LIKE 'R%'
ORDER BY commission_pct ASC NULLS FIRST, last_name DESC;

-- *** The CASE expression

SELECT country_name, region_id,
		CASE region_id WHEN 1 THEN 'Europe'
									 WHEN 2 THEN 'America'
									 WHEN 3 THEN 'Asia'
									 ELSE 'Other' END Continent
FROM countries
WHERE country_name LIKE 'I%';

SELECT first_name, department_id, salary,
		CASE WHEN salary < 6000 THEN 'Low'
				 WHEN salary < 10000 THEN 'Medium'
				 WHEN salary >= 10000 THEN 'High' END Category
FROM employees
WHERE department_id <= 30
ORDER BY first_name;

-- *** Accepting values at runtime
SELECT department_name
FROM departments
WHERE department_id = &dept;

-- Execute in sql plus
DEFINE DEPT = 20
DEFINE DEPT
LIST
/

--A . (dot) is used to append characters immediately after the substitution variable.
SELECT job_id, job_title FROM jobs
WHERE job_id = '&JOB._REP';
/

--You can turn off the old/new display by using the command SET VERIFY OFF.
SELECT &COL1, &COL2
FROM &TABLE
WHERE &COL1 = '&VAL'
ORDER BY &COL2;

SAVE ex01
@ex01
-- FIRST_NAME, LAST_NAME, EMPLOYEES, FIRST_NAME, John, LAST_NAME

--To clear a defined variable, you can use the UNDEFINE command.

--Edit buffer
SELECT &&COL1, &&COL2
FROM &TABLE
WHERE &COL1 = ‘&VAL’
ORDER BY &COL2;

SELECT * FROM departments;
--** Using positional Notation for Variables
SELECT department_name, department_id
FROM departments
WHERE &1 = &2;
--department_id, 20

SAVE ex02
SET VERIFY OFF
@ex02 department_id 20


---------------------------------------------------
SELECT * FROM locations;




---------------------------------------------------
SELECT * FROM regions;




---------------------------------------------------
SELECT * FROM emp_details_view;




---------------------------------------------------

