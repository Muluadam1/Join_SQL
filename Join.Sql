--Retrieve all orders and their corresponding customers

SELECT o.order_id, o.order_date, c.customer_id, c.customer_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

--List all products and their categories, including products with no category.
/*To list all products and their categories, including products with no category, 
you should use a LEFT JOIN between the "products" table and the "categories" table. 
This will ensure that all products from the "products" table are included in the result, 
regardless of whether they have a corresponding category in the "categories" table.

Assuming you have two tables named "products" and "categories," and they have a common column 
named "category_id" in the "products" table that relates to the "categories" table, */

SELECT p.product_id, p.product_name, COALESCE(c.category_name, 'Uncategorized') AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;

/*The COALESCE function is used to handle cases where a product does not have a corresponding category.
If a product has no category (i.e., the category_id is NULL or does not match any category 
in the "categories" table), 
the COALESCE function will replace the NULL value with 'Uncategorized' in the result.
By using a LEFT JOIN, the query will return all products, and for those products that have
a matching category, it will display the corresponding category name. For products without a category, 
it will display 'Uncategorized' in the category_name column.*/

---Show a list of employees and their managers' names (if they have a manager).

/*To show a list of employees and their managers' names (if they have a manager), 
you can use a LEFT JOIN on the "employees" table, where the manager's ID in the "employees" 
table matches the ID of the
employee in the same "employees" table.

Assuming you have a table named "employees" with the following structure:*/

employees
--------------------------------------
| emp_id | emp_name | manager_id |
--------------------------------------

--The SQL query to get the list of employees and their managers' names (if they have a manager) would be:

SELECT e.emp_id, e.emp_name, m.emp_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

/*It is retrieved using the LEFT JOIN, and if an employee doesn't have a manager
(i.e., manager_id is NULL), the manager_name will also be NULL for that employee.
This query will list all employees and display their respective manager's name next to 
their own name. For employees who don't have a manager (i.e., they are at the top level),
the manager_name will be displayed as NULL.*/

--Display all customers and the total amount they've spent on orders.
/*To display all customers and the total amount they've spent on orders, you need to use a combination 
of the "customers" and "orders" tables, and then perform a GROUP BY and SUM operation to calculate the
total amount spent by each customer.

Assuming you have two tables named "customers" and "orders," and they have the following structures:*/

customers
---------------------------------
| customer_id | customer_name |
---------------------------------

orders
-----------------------------------
| order_id | customer_id | amount |
-----------------------------------

/*The customer_id column in the "customers" table corresponds to the customer_id column in the
"orders" table, which establishes the relationship between customers and their orders.
The SQL query to display all customers and the total amount they've spent on orders would be:*/

SELECT c.customer_id, c.customer_name, SUM(o.amount) AS total_amount_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

/*The LEFT JOIN ensures that all customers are included in the result, even if they have not placed 
any orders (i.e., there are no matching records in the "orders" table).
The GROUP BY clause is used to group the results by customer_id and customer_name, allowing 
the SUM function to calculate the total amount spent by each customer.
The SUM function is applied to the amount column, giving the total amount spent by each customer 
on their orders. With this query, you will get a list of all customers along with the total amount
they've spent on their orders. Customers who have not placed any orders will have
a total_amount_spent of NULL.*/

---Retrieve all employees and the territories they are responsible for (use LEFT JOIN).

/*

To retrieve all employees and the territories they are responsible for, you can use a LEFT JOIN 
between the "employees" table and the "territories" table. This will ensure that all employees are 
included in the result, even if they are not responsible for any territories.

Assuming you have two tables named "employees" and "territories," and they have the following structures:*/

employees
----------------------------------------
| emp_id | emp_name | emp_department  |
----------------------------------------

territories
-------------------------------------
| territory_id | territory_name   |
-------------------------------------
| emp_id       | territory_id     |
-------------------------------------

/*The emp_id column in the "employees" table corresponds to the emp_id column in the "territories" table,
which establishes the relationship between employees and the territories they are responsible for.
The SQL query to retrieve all employees and the territories they are responsible for (using LEFT JOIN)
would be:*/

SELECT e.emp_id, e.emp_name, e.emp_department, t.territory_id, t.territory_name
FROM employees e
LEFT JOIN territories t ON e.emp_id = t.emp_id;

/*The LEFT JOIN ensures that all employees are included in the result, even if they have no corresponding
territories in the "territories" table.The ON clause specifies the condition for the JOIN, which is the 
equality of emp_id in both tables.With this query, you will get a list of all employees along with 
the territories they are responsible for. Employees who are not responsible for any territories will 
have NULL values in the territory_id and territory_name columns.*/

---List all customers and the number of orders they've placed (use RIGHT JOIN).

customers
---------------------------------
| customer_id | customer_name |
---------------------------------

orders
-----------------------------------
| order_id | customer_id | amount |
-----------------------------------

SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS number_of_orders
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

---Show a list of products and the number of times each product has been ordered (use INNER JOIN).

products
-----------------------------
| product_id | product_name |
-----------------------------

orders
-----------------------------------
| order_id | customer_id | amount |
-----------------------------------

SELECT p.product_id, p.product_name, COUNT(o.order_id) AS number_of_orders
FROM products p
INNER JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;

/*The INNER JOIN ensures that only the products with matching orders are included in the result. 
Products that have not been ordered will be excluded from the result.*/

---Display all employees and the number of orders they've taken (use OUTER JOIN).

employees
----------------------------------------
| emp_id | emp_name | emp_department  |
----------------------------------------

orders
-----------------------------------
| order_id | employee_id | amount |
-----------------------------------

SELECT e.emp_id, e.emp_name, e.emp_department, COUNT(o.order_id) AS number_of_orders
FROM employees e
LEFT JOIN orders o ON e.emp_id = o.employee_id
GROUP BY e.emp_id, e.emp_name, e.emp_department;
 --or
 SELECT e.emp_id, e.emp_name, e.emp_department, COUNT(o.order_id) AS number_of_orders
FROM employees e
RIGHT JOIN orders o ON e.emp_id = o.employee_id
GROUP BY e.emp_id, e.emp_name, e.emp_department;

/*The LEFT JOIN ensures that all employees are included in the result, even 
if they have not taken any orders. Employees who have not taken any orders will have a
number_of_orders value of 0.*/

--List all categories and the average price of products in each category.

categories
---------------------------------
| category_id | category_name  |
---------------------------------

products
----------------------------------------------
| product_id | product_name | category_id | price |
----------------------------------------------

SELECT c.category_id, c.category_name, AVG(p.price) AS average_price
FROM categories c
INNER JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;

/*The INNER JOIN ensures that only the categories with matching products are included in the result.
Categories that have no products will be excluded from the result.*/

---Show a list of customers who have not placed any orders (use LEFT JOIN and check for NULLs).
customers
---------------------------------
| customer_id | customer_name |
---------------------------------

orders
-----------------------------------
| order_id | customer_id | amount |
-----------------------------------

SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/*
The LEFT JOIN ensures that all customers are included in the result, even if they have not placed any orders. 
Customers without orders will have NULL values in the order_id column from the "orders" table.*/

/*Retrieve all employees and the number of orders they've processed, 
showing 0 for employees without orders (use LEFT JOIN).*/

employees
----------------------------------------
| emp_id | emp_name | emp_department  |
----------------------------------------

orders
-----------------------------------
| order_id | employee_id | amount |
-----------------------------------

SELECT e.emp_id, e.emp_name, e.emp_department, COUNT(o.order_id) AS number_of_orders_processed
FROM employees e
LEFT JOIN orders o ON e.emp_id = o.employee_id
GROUP BY e.emp_id, e.emp_name, e.emp_department;

/*The LEFT JOIN ensures that all employees are included in the result, even if they have not processed
any orders. Employees without orders will have a number_of_orders_processed value of 0.*/

/*List all employees and the number of orders they've taken, ordered by the number of orders in 
descending order (use INNER JOIN).*/

employees
----------------------------------------
| emp_id | emp_name | emp_department  |
----------------------------------------

orders
-----------------------------------
| order_id | employee_id | amount |
-----------------------------------

SELECT e.emp_id, e.emp_name, e.emp_department, COUNT(o.order_id) AS number_of_orders_taken
FROM employees e
INNER JOIN orders o ON e.emp_id = o.employee_id
GROUP BY e.emp_id, e.emp_name, e.emp_department
ORDER BY number_of_orders_taken DESC;

/*The INNER JOIN ensures that only the employees with matching orders are included in the result. 
Employees who have not taken any orders will be excluded from the result.*/

/*Show a list of orders and the customer details, but also include orders without 
any customer information (use RIGHT JOIN).*/

orders
-----------------------------------
| order_id | customer_id | amount |
-----------------------------------

customers
---------------------------------
| customer_id | customer_name |
---------------------------------

SELECT o.order_id, o.customer_id, c.customer_name, o.amount
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

/*The RIGHT JOIN ensures that all orders are included in the result, even if they have no corresponding 
customer information. Orders without customer information will have NULL values in the customer_id 
and customer_name columns from the "customers" table.*/

--Retrieve all customers who have placed orders in the last 30 days (use INNER JOIN and date filtering).

customers
---------------------------------
| customer_id | customer_name |
---------------------------------

orders
-----------------------------------
| order_id | customer_id | order_date |
-----------------------------------

SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

/*The INNER JOIN ensures that only customers who have placed orders are included in the result. 
Customers who haven't placed any orders will be excluded.*/

/*List all products and their corresponding categories, 
excluding products that don't have a category (use INNER JOIN).*/

products
-----------------------------
| product_id | product_name |
-----------------------------

categories
---------------------------------------
| category_id | category_name  |
---------------------------------------
| product_id  | category_id    |
---------------------------------------

SELECT p.product_id, p.product_name, c.category_name
FROM products p
INNER JOIN categories c ON p.product_id = c.product_id;

/*The INNER JOIN ensures that only products with a matching category (i.e., products that have a 
corresponding entry in the "categories" table) will be included in the result. 
Products without a category will be excluded.*/

--Show a list of employees and the total revenue generated from the orders they've taken (use OUTER JOIN).

employees
----------------------------------------
| emp_id | emp_name | emp_department  |
----------------------------------------

orders
-----------------------------------
| order_id | employee_id | amount |
-----------------------------------

SELECT e.emp_id, e.emp_name, e.emp_department, SUM(o.amount) AS total_revenue
FROM employees e
LEFT JOIN orders o ON e.emp_id = o.employee_id
GROUP BY e.emp_id, e.emp_name, e.emp_department;

/*The LEFT JOIN ensures that all employees are included in the result, even if they have not taken any orders. 
Employees without orders will have a total_revenue value of NULL.*/

/*Retrieve all orders and the products they contain, 
displaying orders even if they have no associated products (use LEFT JOIN).*/

orders
------------------------
| order_id | order_date |
------------------------

order_items (or products)
-------------------------------------------
| item_id | order_id | product_id | quantity |
-------------------------------------------

SELECT o.order_id, o.order_date, oi.product_id, oi.quantity
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id;

/*The LEFT JOIN ensures that all orders from the "orders" table are included in the result, 
even if they have no associated products in the "order_items" (or "products") table.*/