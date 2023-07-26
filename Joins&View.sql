--JOIN&VIEW

--SYNTAX OF THE 'INNER JOIN'
--The syntax used to join two tables is as follows:
/*SELECT columns
  FROM table_A
  INNER JOIN table_B ON join_conditions*/

--The syntax used to join three or more tables is as follows:
  /*  SELECT columns
  FROM table_A
  INNER JOIN table_B 
  ON join_conditions1 AND join_conditions2
  INNER JOIN table_C
  ON join_conditions3 OR join_conditions4*/

  SELECT *
  FROM sale.orders AS ord
  INNER JOIN sale.order_item AS item
  ON ord.order_id = item.order_id;

  SELECT ord.order_id, item.order_id, ord.order_date, item.list_price
  FROM sale.orders AS ord
  INNER JOIN sale.order_item AS item
  ON ord.order_id = item.order_id;

  SELECT ord.order_id, item.order_id, ord.order_date, item.list_price
  FROM sale.orders AS ord
  INNER JOIN sale.order_item AS item
  ON ord.order_id = item.order_id AND item.list_price < 15;

  SELECT *
  FROM sale.orders AS ord
  INNER JOIN sale.order_item AS item
  ON ord.order_id = item.order_id
  INNER JOIN product.product AS prod
  On prod.list_price = item.list_price;

  SELECT ord.customer_id, prod.product_name,ord.order_id, item.order_id, prod.list_price, item.list_price
  FROM sale.orders AS ord
  INNER JOIN sale.order_item AS item
  ON ord.order_id = item.order_id
  INNER JOIN product.product AS prod
  On prod.list_price = item.list_price;

   SELECT ord.customer_id, prod.product_name,ord.order_id, item.order_id, ord.shipped_date, prod.list_price, item.list_price
  FROM sale.orders AS ord
  INNER JOIN sale.order_item AS item
  ON ord.order_id = item.order_id AND ord.order_status = 3
  INNER JOIN product.product AS prod
  On prod.list_price = item.list_price
  ORDER BY ord.order_id ASC;


--SYNTAX OF THE 'LEFT JOIN'
/*SELECT columns
  FROM table_A
  LEFT JOIN table_B ON join_conditions*/

  SELECT prod.product_id, stock.product_id, prod.product_name, prod.list_price
  FROM product.product AS prod
  LEFT JOIN product.stock AS stock
  ON prod.product_id = stock.product_id;

  SELECT prod.product_id AS p_id, stock.product_id AS s_id, prod.product_name, prod.list_price
  FROM product.product AS prod
  LEFT JOIN product.stock AS stock
  ON prod.product_id = stock.product_id AND prod.list_price > 1000
  WHERE prod.product_name LIKE '%Samsung%'
  ORDER BY prod.product_id ASC, prod.list_price DESC;

  SELECT prod.product_id AS p_id, stock.product_id AS s_id, prod.product_name,prod.list_price
  FROM product.product AS prod
  LEFT JOIN product.stock AS stock
  ON prod.product_id = stock.product_id AND prod.list_price > 1000
  WHERE prod.product_name LIKE '%Samsung%'
  ORDER BY stock.product_id DESC, prod.list_price DESC;
  
  SELECT customer.state AS c_state, store.state AS s_state
  FROM sale.customer AS customer
  LEFT JOIN sale.store AS store
  ON customer.state = store.state
  WHERE customer.state LIKE 'CA' OR customer.state LIKE 'AZ'
  ORDER BY s_state DESC, c_state ASC;


--SYNTAX OF THE 'RIGHT JOIN'
/*SELECT columns
  FROM table_A
  LEFT JOIN table_B ON join_conditions*/

--'RIGHT JOIN' and 'RIGHT OUTER JOIN' keywords are exactly the same. OUTER keyword is optional.

SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS full_name, staff.staff_id AS s_id, orders.staff_id AS o_id
FROM sale.orders AS orders
RIGHT JOIN sale.staff AS staff
ON staff.staff_id = orders.staff_id;

SELECT DISTINCT CONCAT(staff.first_name, ' ', staff.last_name) AS full_name, staff.staff_id AS s_id, orders.staff_id AS o_id
FROM sale.orders AS orders
RIGHT JOIN sale.staff AS staff
ON staff.staff_id = orders.staff_id;


SELECT item.order_id AS i_id, orders.order_id AS o_id, product.product_name, product.list_price AS p_price, item.list_price AS i_price
FROM sale.order_item AS item
RIGHT OUTER JOIN sale.orders AS orders
ON item.order_id = orders.order_id
RIGHT OUTER JOIN product.product AS product
ON product.list_price = item.list_price
WHERE product.list_price > 600
ORDER BY item.list_price ASC;


--SYNTAX OF THE 'CROSS JOIN'
/*SELECT columns
  FROM table_A
  CROSS JOIN table_B
or
  SELECT columns
  FROM table_A, table_B*/

SELECT b.store_id, a.product_id
FROM product.product a
CROSS JOIN sale.store b;

SELECT b.store_id, a.product_id
FROM product.product a, sale.store b;


SELECT  a.product_id, b.store_id, COALESCE(NULL, c.quantity, 0) quantity
FROM product.product a
CROSS JOIN sale.store b
LEFT JOIN product.stock c 
ON a.product_id=c.product_id 
AND b.store_id=c.store_id
ORDER BY 1 ASC, 3 DESC;


SELECT p.product_id, s.store_id, 0 AS quantity
FROM product.product p
	 CROSS JOIN sale.store s
WHERE p.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY 1,2;

--SYNTAX OF THE 'SELF JOIN'
/*SELECT columns
  FROM table A 
  JOIN table B 
  WHERE join_conditions*/
  --We use INNER JOIN or LEFT JOIN for creating a self join.
 SELECT * FROM sale.staff

SELECT a.staff_id, a.first_name, a.last_name, a.manager_id, b.first_name manager_name
FROM sale.staff a
	 LEFT JOIN sale.staff b ON a.manager_id=b.staff_id;


SELECT a.first_name, a.last_name, a.manager_id, b.first_name manager_name
FROM sale.staff a
	 INNER JOIN sale.staff b ON a.manager_id=b.staff_id;


--QUESTION-1
--Write a query that returns both the names of staff and the names of their 1st and 2nd managers

SELECT s.first_name, s.last_name, s.manager_id, 
    m1.first_name first_manager_name, m2.first_name second_manager_name
FROM sale.staff s
	 INNER JOIN sale.staff m1 ON s.manager_id=m1.staff_id
	 INNER JOIN sale.staff m2 ON m1.manager_id = m2.staff_id;


	 SELECT s.first_name, s.last_name, s.manager_id, 
    m1.first_name first_manager_name, m2.first_name second_manager_name
FROM sale.staff s
	 LEFT JOIN sale.staff m1 ON s.manager_id=m1.staff_id
	 LEFT JOIN sale.staff m2 ON m1.manager_id = m2.staff_id;

--QUESTION-2
--Write a query that returns the order date of the product named "Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black".
	 
SELECT o.order_date
FROM sale.orders o
LEFT JOIN sale.order_item i ON i.order_id=o.order_id
LEFT JOIN product.product p ON p.product_id=i.product_id
WHERE p.product_name = 'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black';

SELECT o.order_date
FROM sale.orders o
INNER JOIN sale.order_item i ON i.order_id=o.order_id
INNER JOIN product.product p ON p.product_id=i.product_id
WHERE p.product_name = 'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black';

--QUESTION-3
--Write a query that returns orders of the products branded "Seagate". It should be listed Product names and order IDs of all the products ordered or not ordered. (order_id in ascending order)

SELECT p.product_name, i.order_id
FROM product.product p
LEFT JOIN sale.order_item i ON i.product_id=p.product_id
WHERE p.product_name LIKE '%Seagate%'
ORDER BY i.order_id ASC;

SELECT TOP 10 p.product_name, i.order_id
FROM product.product p
LEFT JOIN sale.order_item i ON i.product_id=p.product_id
LEFT JOIN product.brand b ON b.brand_id=p.brand_id
WHERE p.product_name LIKE '%Seagate%'
ORDER BY i.order_id ASC;




--SYNTAX OF THE 'FULL OUTER JOIN'
/*SELECT columns
  FROM table_A
  FULL OUTER JOIN table_B ON join_conditions*/
  --All rows are returned from both tables regardless of matching data.

SELECT p.product_id, SUM(s.quantity) total_quantity
FROM product.product AS p
	 FULL JOIN product.stock s
	 ON p.product_id=s.product_id
GROUP BY p.product_id
ORDER BY 1,2;
GO
--NOTE: When we create views, than if we want to execute all the statements we'll get an error. But as long as we use 'GO' keyword, we can avoid the getting the error.

--VIEWS
/*
ADVANTAGES OF VIEWS
1-Performance
2-Security
3-Simplicity
4-Storage
*/

--Example-1
--Create a view that shows the products customers ordered

CREATE VIEW vw_customers_sale AS
SELECT c.customer_id,c.first_name,c.last_name,o.order_id,i.product_id,p.product_name
FROM sale.customer c
	LEFT JOIN sale.orders o ON o.customer_id=c.customer_id
	LEFT JOIN sale.order_item i ON i.order_id=o.order_id
	LEFT JOIN product.product p ON p.product_id=i.product_id;

SELECT * FROM [dbo].[vw_customers_sale]

EXEC sp_helptext [vw_customers_sale]

--We can update the views using by 'ALTER; keyword
--In this view I deleted 'o.order_id' column
ALTER VIEW vw_customers_sale AS  
SELECT c.customer_id,c.first_name,c.last_name,i.product_id,p.product_name  
FROM sale.customer c  
 LEFT JOIN sale.orders o ON o.customer_id=c.customer_id  
 LEFT JOIN sale.order_item i ON i.order_id=o.order_id  
 LEFT JOIN product.product p ON p.product_id=i.product_id;

 DROP VIEW [vw_customers_sale] 
