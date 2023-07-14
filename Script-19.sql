USE day_10_14_db;

SELECT * FROM departments;

SELECT * FROM employees;

SELECT * FROM employees AS em
WHERE EXISTS(
  SELECT * FROM departments AS dt WHERE em.department_id = dt.id
);

SELECT * FROM employees as em
WHERE em.department_id IN (SELECT id FROM departments);


SELECT * FROM employees AS em
WHERE EXISTS (
   SELECT * FROM departments AS dt WHERE dt.name IN("営業部", "開発部") AND em.department_id = dt.id
)

SELECT * FROM customers AS ct
WHERE NOT EXISTS(
  SELECT * FROM orders AS od WHERE ct.id = od.customer_id AND od.order_date = "2020-12-31"
 )
 
SELECT * FROM employees AS em1
WHERE EXISTS (SELECT 1 FROM employees em2 WHERE em1.manager_id = em2.id);


SELECT * FROM customers AS c1
WHERE EXISTS 
(SELECT * FROM customers_2 AS c2
WHERE c1.first_name = c2.first_name AND c1.last_name = c2.last_name AND 
(c1.phone_number = c2.phone_number or (c1.phone_number IS NULL AND c2.phone_number IS NULL)));


SELECT * FROM customers AS c1
WHERE NOT EXISTS 
(SELECT * FROM customers_2 AS c2
WHERE c1.first_name = c2.first_name AND c1.last_name = c2.last_name AND c1.phone_number = c2.phone_number);

SELECT * FROM customers
UNION
SELECT * FROM customers_2;

SELECT * FROM customers AS c1
WHERE NOT EXISTS(
  SELECT * FROM customers_2 AS c2
  WHERE 
  c1.id = c2.id AND 
  c1.first_name = c2.first_name AND
  c1.last_name = c2.last_name AND
  c1.phone_number = c2.phone_number AND 
  c1.age = c2.age 
);

SELECT emp.id, emp.first_name, emp.last_name, dt.id AS department_id, dt.name AS department_name
FROM employees AS emp
INNER JOIN departments AS dt
ON emp.department_id = dt.id;

SELECT * FROM students AS std
INNER JOIN
 users AS usr
ON std.first_name = usr.first_name AND std.last_name = usr.last_name;

SELECT * FROM employees AS emp
INNER JOIN
  students AS std
 ON emp.id < std.id
 
SELECT emp.id, emp.first_name, emp.last_name, COALESCE(dt.id, "該当なし") AS department_id, dt.name AS department
FROM employees AS emp
LEFT JOIN departments AS dt
ON emp.department_id  = dt.id;

SELECT 
  ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name 
FROM 
  customers AS ct
INNER JOIN orders AS od 
ON ct.id = od.customer_id 
INNER JOIN items AS it
ON od.item_id = it.id 
INNER JOIN stores AS st
ON it.store_id = st.id
WHERE ct.id = 10 AND od.order_date >"2020-08-01"
ORDER BY ct.id;

SELECT 
  ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name 
FROM 
  (SELECT * FROM customers WHERE id=10) AS ct
INNER JOIN (SELECT * FROM orders WHERE order_date > "2020-08-01") AS od 
ON ct.id = od.customer_id 
INNER JOIN items AS it
ON od.item_id = it.id 
INNER JOIN stores AS st
ON it.store_id = st.id
ORDER BY ct.id;

SELECT * FROM customers AS ct
INNER JOIN
    (SELECT customer_id, SUM(order_amount * order_price) AS summary_price
     FROM orders
     GROUP BY customer_id) AS order_summary
ON ct.id = order_summary.customer_id
ORDER BY ct.age
LIMIT 5;
    
SELECT 
   CONCAT(emp1.last_name, emp1.first_name) AS "部下の名前",
   emp1.age AS "部下の年齢",
   COALESCE(CONCAT(emp2.last_name, emp2.first_name), "該当なし") AS "上司の名前",
   COALESCE((emp2.age),"不明") AS "上司の年齢"
FROM employees AS emp1
LEFT JOIN employees AS emp2
ON emp1.manager_id = emp2.id;

SELECT *,
CASE 
   WHEN cs.age > summary_customers.avg_age THEN "◯"
   ELSE "×"
END AS "平均年齢よりも年齢が高いか"
FROM customers AS cs
CROSS JOIN(
SELECT AVG(age) AS avg_age FROM customers
) AS summary_customers;

SELECT
emp.id, AVG(payment), summary.avg_payment,
CASE
  WHEN AVG(payment) >= summary.avg_payment THEN "◯"
  ELSE "×"
END AS "平均月収以上か"
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id
CROSS JOIN
(SELECT AVG(payment) AS avg_payment FROM salaries) AS summary
GROUP BY emp.id, summary.avg_payment;

SELECT 
*
FROM employees AS e
INNER JOIN departments AS d 
ON e.department_id = d.id 
WHERE d.name = "営業部"


WITH tmp_departments AS(
  SELECT * FROM departments WHERE name="営業部"
)
SELECT * FROM employees AS e
INNER JOIN tmp_departments
ON e.department_id = tmp_departments.id;


WITH tmp_stores AS (
   SELECT * FROM stores WHERE id IN (1, 2, 3)
), tmp_items_orders AS (
   SELECT items.id AS item_id,
   orders.id AS order_id,
   tmp_stores.id AS store_id,
   orders.order_amount AS order_amount,
   orders.order_price AS order_price,
   tmp_stores.name AS store_name
   FROM tmp_stores
   INNER JOIN items 
   ON tmp_stores.id = items.store_id
   INNER JOIN orders 
   ON items.id = orders.item_id
)
SELECT store_name, SUM(order_amount * order_price)
FROM tmp_items_orders GROUP BY store_name;



