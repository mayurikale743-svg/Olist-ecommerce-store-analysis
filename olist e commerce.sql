#Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT
    CASE
        WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(SUM(p.payment_value)*100/
    (select sum(payment_value) from order_payments),2) AS Total_Payment
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
GROUP BY Day_Type;

# Number of Orders with review score 5 and payment type as credit card.

SELECT COUNT(DISTINCT o.order_id) AS Total_Orders
FROM orders o
JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id
JOIN order_payments p
    ON o.order_id = p.order_id
WHERE r.review_score = 5
  AND p.payment_type = 'credit_card';
  
  
#Average number of days taken for order_delivered_customer_date for pet_shop


SELECT
ROUND(
AVG(
DATEDIFF(
o.order_delivered_customer_date,
o.order_purchase_timestamp
)
),2
) AS Avg_Delivery_Days
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_category_name = 'pet_shop'
AND o.order_delivered_customer_date IS NOT NULL;

#Average price and payment values from customers of sao paulo city

SELECT
    ROUND(AVG(oi.price),2) AS Avg_Price,
    ROUND(AVG(op.payment_value),2) AS Avg_Payment_Value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN order_payments op
    ON o.order_id = op.order_id
WHERE LOWER(c.customer_city) = 'sao paulo';


#Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.


SELECT
    r.review_score,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),2
    ) AS Avg_Shipping_Days
FROM orders o
JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

#Top 10 Cities by Revenue

SELECT
    c.customer_city,
    ROUND(SUM(op.payment_value),2) AS Total_Revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY c.customer_city
ORDER BY Total_Revenue DESC
LIMIT 10;

#Total Orders by Year

SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Order_Year;

