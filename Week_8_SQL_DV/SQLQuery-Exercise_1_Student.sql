


---- 1. List all the cities in the Texas and the numbers of customers in each city.----

SELECT city, COUNT(customer_id) AS num_customers
FROM sale.customer 
WHERE state = 'TX'
GROUP BY city;

---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---

SELECT city, COUNT(customer_id) AS num_customers
FROM sale.customer
WHERE state = 'CA'
AND customer_id > 5
GROUP BY city
ORDER BY num_customers DESC;

SELECT state, city, COUNT(customer_id) FROM sale.customer
WHERE state = 'CA'
GROUP BY city, state
having count(customer_id) > 5
order by count(customer_id) desc

---- 3. List the top 10 most expensive products----

SELECT TOP 10 product_name, list_price FROM product.product
ORDER BY list_price DESC;


---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----
SELECT s.store_id, p.product_name, p.list_price, s.quantity 
FROM product.stock s
LEFT JOIN product.product p ON s.product_id = p.product_id
WHERE store_id = 2
AND quantity >= 25


---- 5. Find the sales order of the customers who lives in Boulder order by order date----

SELECT city, order_id, order_date
FROM sale.orders o
JOIN sale.customer c ON o.customer_id = c.customer_id
WHERE c.city = 'Boulder'
ORDER BY order_date


---- 6. Get the sales by staffs and years using the AVG() aggregate function.

SELECT sale.orders.staff_id, sale.staff.first_name, sale.staff.last_name,
YEAR(order_date) AS order_year,
AVG(order_item.list_price) AS avg_price
FROM sale.staff
JOIN sale.orders ON orders.staff_id = staff.staff_id
JOIN sale.order_item ON order_item.order_id = orders.order_id
GROUP BY orders.staff_id, staff.first_name, staff.last_name, YEAR(order_date)
ORDER BY staff_id


-- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----

SELECT b.brand_name, count(oi.quantity) AS total_quantity FROM sale.order_item oi
JOIN product.product p ON oi.product_id = p.product_id
JOIN product.brand b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY total_quantity DESC;

SELECT b.brand_name, COUNT(quantity) AS total_quantity
FROM product.brand b
LEFT JOIN product.product p ON b.brand_id = p.brand_id
LEFT JOIN sale.order_item oi ON p.product_id = oi.product_id
GROUP BY  brand_name
ORDER BY total_quantity DESC;

---- 8. What are the categories that each brand has?----

SELECT * FROM product.brand
SELECT * FROM product.category

SELECT  DISTINCT b.brand_name, ct.category_name FROM product.brand b
LEFT JOIN product.product p ON b.brand_id = p.brand_id
LEFT JOIN product.category ct ON p.category_id = ct.category_id
ORDER BY b.brand_name



---- 9. Select the avg prices according to brands and categories----
 
 SELECT brand_name, category_name, AVG(list_price) avg_price FROM product.product p
 LEFT JOIN product.brand b ON p.brand_id = b.brand_id
 LEFT JOIN product.category c ON p.category_id = c.category_id
 GROUP BY b.brand_name, c.category_name

---- 10. Select the annual amount of product produced according to brands----


SELECT * FROM product.stock

SELECT * FROM product.product

SELECT b.brand_name, p.model_year, SUM(quantity) annual_quantity
FROM product.stock s
LEFT JOIN product.product p ON s.product_id = p.product_id
LEFT JOIN product.brand b ON p.brand_id = b.brand_id
GROUP BY b.brand_name, p.model_year


---- 11. Select the store which has the most sales quantity in 2018.----


SELECT TOP 1 o.store_id, s.store_name, SUM(oi.quantity) AS total_quantity_in_2018
FROM sale.orders o
     INNER JOIN sale.order_item oi
ON o.order_id = oi.order_id
     INNER JOIN sale.store s
ON o.store_id = s.store_id
WHERE YEAR(order_date) = 2018
GROUP BY o.store_id, s.store_name
ORDER BY SUM(oi.quantity) DESC;


---- 12 Select the store which has the most sales amount in 2018.----

SELECT top 1 o.store_id, s.store_name, SUM((list_price * (1- discount))* oi.quantity) AS most_amoount_of_store FROM sale.orders o
JOIN sale.store s ON s.store_id = o.store_id
JOIN sale.order_item oi ON o.order_id = oi.order_id
WHERE YEAR(order_date) = 2018
GROUP BY o.store_id, s.store_name
ORDER BY most_amoount_of_store DESC


---- 13. Select the personnel which has the most sales amount in 2019.----

SELECT top 1 sf.staff_id, sf.first_name, sf.last_name, SUM(oi.list_price * (1- discount)) AS total_amount_2019 FROM sale.staff sf
JOIN sale.orders o ON sf.staff_id = o.staff_id
JOIN sale.order_item oi ON o.order_id = oi.order_id
WHERE YEAR(order_date) = 2019
GROUP BY sf.staff_id,  sf.first_name, sf.last_name
ORDER BY total_amount_2019 DESC
