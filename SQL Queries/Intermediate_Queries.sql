-- ===========================================
-- INTERMEDIATE SQL QUERIES
-- ===========================================

-- 1. Total sales by product category

SELECT
products.product_category AS category,
ROUND(SUM(payments.payment_value),2) AS total_sales
FROM products
JOIN order_items
ON products.product_id = order_items.product_id
JOIN payments
ON payments.order_id = order_items.order_id
GROUP BY category
ORDER BY total_sales DESC;


-- 2. Monthly orders in 2018

SELECT
MONTHNAME(order_purchase_timestamp) AS month,
COUNT(order_id) AS total_orders
FROM orders
WHERE YEAR(order_purchase_timestamp)=2018
GROUP BY month;


-- 3. Average products per order grouped by city

WITH count_per_order AS
(
SELECT
orders.order_id,
orders.customer_id,
COUNT(order_items.order_id) AS products
FROM orders
JOIN order_items
ON orders.order_id=order_items.order_id
GROUP BY orders.order_id,orders.customer_id
)

SELECT
customers.customer_city,
ROUND(AVG(products),2) AS average_products
FROM count_per_order
JOIN customers
ON customers.customer_id=count_per_order.customer_id
GROUP BY customers.customer_city;


-- 4. Revenue contribution by category

SELECT
products.product_category,
ROUND(
SUM(payments.payment_value)/
(SELECT SUM(payment_value) FROM payments)*100,2
) AS revenue_percentage
FROM products
JOIN order_items
ON products.product_id=order_items.product_id
JOIN payments
ON payments.order_id=order_items.order_id
GROUP BY products.product_category;


-- 5. Correlation between product price and purchases

SELECT
products.product_category,
COUNT(order_items.product_id) AS product_count,
ROUND(AVG(order_items.price),2) AS average_price
FROM products
JOIN order_items
ON products.product_id=order_items.product_id
GROUP BY products.product_category;