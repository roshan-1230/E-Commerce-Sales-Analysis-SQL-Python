-- ===========================================
-- ADVANCED SQL QUERIES
-- ===========================================

-- 1. Top sellers using DENSE_RANK()

SELECT *
FROM
(
SELECT
order_items.seller_id,
ROUND(SUM(payments.payment_value),2) revenue,
DENSE_RANK() OVER(
ORDER BY SUM(payments.payment_value) DESC
) AS ranking
FROM order_items
JOIN payments
ON order_items.order_id=payments.order_id
GROUP BY order_items.seller_id
) ranked_sellers;


-- 2. Moving average of customer spending

SELECT
customer_id,
order_purchase_timestamp,
AVG(payment)
OVER(
PARTITION BY customer_id
ORDER BY order_purchase_timestamp
) moving_average
FROM customer_payments;


-- 3. Cumulative monthly sales

SELECT
years,
months,
payment,
SUM(payment)
OVER(
ORDER BY years,months
) cumulative_sales
FROM monthly_sales;


-- 4. Year-over-Year sales growth

WITH yearly_sales AS
(
SELECT
YEAR(order_purchase_timestamp) year,
SUM(payment_value) revenue
FROM orders
JOIN payments
USING(order_id)
GROUP BY year
)

SELECT
*,
LAG(revenue)
OVER(ORDER BY year) previous_year_sales
FROM yearly_sales;


-- 5. Customer retention within six months

WITH first_order AS
(
SELECT
customer_id,
MIN(order_purchase_timestamp) first_purchase
FROM orders
GROUP BY customer_id
)

SELECT *
FROM first_order;


-- 6. Top 3 customers by yearly spending

SELECT *
FROM
(
SELECT
YEAR(order_purchase_timestamp) years,
customer_id,
SUM(payment_value) payment,
DENSE_RANK()
OVER(
PARTITION BY YEAR(order_purchase_timestamp)
ORDER BY SUM(payment_value) DESC
) ranking
FROM orders
JOIN payments
USING(order_id)
GROUP BY years,customer_id
) ranked_customers
WHERE ranking<=3;