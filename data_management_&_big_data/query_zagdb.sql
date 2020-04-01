show databases;
use zagdb;
SELECT vendorid, vendorname FROM vendor;
SELECT customername, customerzip FROM customer;
SELECT productid, productname, productprice FROM product WHERE productprice >= 100;
SELECT productid, productname, productprice, vendorname 
	FROM product AS p INNER JOIN vendor AS v
	ON p.vendorid = v.vendorid
	ORDER BY productid;
SELECT productid, productname, productprice, vendorname, categoryname 
	FROM product AS p INNER JOIN vendor AS v
	ON p.vendorid = v.vendorid INNER JOIN category as c
	ON p.categoryid = c.categoryid
	ORDER BY productid;
SELECT productid, productname, productprice 
	FROM product AS p INNER JOIN category AS c
	ON p.categoryid = c.categoryid
	WHERE c.categoryname = 'Camping'
	ORDER BY productid;
SELECT s.tid, cu.customername, s.tdate 
	FROM salestransaction AS s INNER JOIN customer AS cu
  	ON s.customerid = cu.customerid INNER JOIN soldvia as sv
	ON s.tid = sv.tid INNER JOIN product AS p
	ON sv.productid = p.productid
 	WHERE productname = 'Dura Boot';
SELECT r.regionid, r.regionname, count(*)
	FROM region AS r, store AS s
	WHERE r.regionid = s.regionid
	GROUP BY r.regionid, r.regionname
	ORDER BY count(*) DESC;
SELECT c.categoryid, c.categoryname, AVG(p.productprice)
	FROM category AS c INNER JOIN product AS p
	ON c.categoryid = p.categoryid
	GROUP BY c.categoryid, c.categoryname;
SELECT c.categoryid, c.categoryname, AVG(p.productprice)
 	FROM category c, product p
	WHERE c.categoryid = p.categoryid
	GROUP BY c.categoryid, c.categoryname;
SELECT c.categoryid, SUM(sv.noofitems)
	FROM category c, product p, soldvia sv
	WHERE c.categoryid = p.categoryid
	AND p.productid = sv.productid
	GROUP BY c.categoryid;
SELECT tid, SUM(sv.noofitems) 
	FROM soldvia AS sv
	GROUP BY tid
	HAVING SUM(noofitems) > 5;
SELECT productid, productname
	FROM product HAVING MIN(productprice);
SELECT p.productname, p.productid, v.vendorname
	FROM product as p INNER JOIN vendor AS v
	ON p.vendorid = p.vendorid
	WHERE p.productprice < AVG(p.productprice);
SELECT productid FROM soldvia
	GROUP BY productid 
	ORDER BY SUM(noofitems) DESC
	LIMIT 1;
SELECT p.productid, productname, productprice
	FROM product p INNER JOIN soldvia s
	ON p.productid = s.productid
	GROUP BY p.productid HAVING SUM(s.noofitems) > 3;    
SELECT p.productid, productname, productprice
	FROM product p INNER JOIN soldvia s
	ON p.productid = s.productid
	GROUP BY p.productid HAVING COUNT(s.tid) > 1;




