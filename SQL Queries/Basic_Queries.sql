-- ===========================================
-- BASIC SQL QUERIES
-- ===========================================

-- 1. List all unique customer cities

SELECT DISTINCT customer_city
FROM customers;


-- 2. Count the number of orders placed in 2017

SELECT COUNT(order_id) AS total_orders_2017
FROM orders
WHERE YEAR(order_purchase_timestamp) = 2017;


-- 3. Count customers from each state

SELECT
    customer_state,
    COUNT(customer_id) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC;


-- 4. Calculate percentage of installment payments

SELECT
ROUND(
SUM(CASE
WHEN payment_installments >= 1 THEN 1
ELSE 0
END) *100 / COUNT(*),2)
AS installment_percentage
FROM payments;