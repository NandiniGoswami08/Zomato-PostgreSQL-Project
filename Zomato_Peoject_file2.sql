--EDA
--IMPORT DATASETS
SELECT * FROM CUSTOMERS;
SELECT * FROM RESTAURANTS;
SELECT * FROM ORDERS;
SELECT * FROM RIDERS;
SELECT * FROM DELIVERY;

--HANDLING NULL VALUES

SELECT COUNT(*) FROM RESTAURANTS
WHERE restaurant_name IS NULL OR city IS NULL OR opening_hours IS NULL;

SELECT COUNT(*) FROM ORDERS
WHERE customer_id IS NULL OR restaurant_id IS NULL OR order_item IS NULL
OR order_date IS NULL OR order_time IS NULL OR order_status IS NULL OR total_amount IS NULL;

--IF WE WANT TO SEE NULL VALUES IN TABLE THEN 
--INSERT INTO ORDERS(order_id, customer_id,restaurant_id) VALUES 
--(1002, 9, 54),(1003,10,51),(1005,10,50);

--DELETE FROM orders WHERE order_item IS NULL
--OR order_date IS NULL OR order_time IS NULL OR order_status IS NULL OR total_amount IS NULL;   (TO DELETE THE DATA)


-------------------------------
--   ANALYSIS REPORTS
-------------------------------



--Q.1
-- Write a query to find the top 5 most frequently ordered dishes by customer called "james ruiz" in the last 1 year.

SELECT C.customer_id, C.customer_name, O.order_item as dishes,
COUNT(*) AS total_order 
FROM ORDERS AS O
JOIN
CUSTOMERS AS C
ON C.customer_id=O.customer_id
WHERE O.order_date>=CURRENT_DATE-INTERVAL '1 YEAR'
AND C.customer_name='James Ruiz'
GROUP BY 1, 2, 3
ORDER BY 1, 4 DESC LIMIT 5;

SELECT CURRENT_DATE-INTERVAL '1 YEAR'



--Q.2 Popular Time Slots
-- Question: Identify the time slots during which the most orders are placed, based on 2-hour interval

SELECT * FROM ORDERS;

SELECT 
CASE
    WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00-02:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN '02:00-04:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN '04:00-06:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN '06:00-08:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN '08:00-10:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN '10:00-12:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN '12:00-14:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN '14:00-16:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN '16:00-18:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN '18:00-20:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN '20:00-22:00'
	WHEN EXTRACT(HOUR FROM order_time) BETWEEN 22 AND 23 THEN '22:00-00:00'
END AS time_slot,
COUNT(order_id) AS order_count
FROM ORDERS
GROUP BY time_slot
ORDER BY order_count DESC;



--Q.3 ORDER VALUE ANALYSIS
-- Find the average order value per customer who has placed more than 4 orders.

SELECT * FROM ORDERS;

SELECT C.customer_name, 
AVG(O.total_amount) as AOV
--COUNT(order_id) as total_orders
FROM ORDERS as O
JOIN CUSTOMERS AS C 
ON C.customer_id=O.customer_id
GROUP BY 1
having count(order_id)>4



--Q.4 High value Customer
-- List the customers who have spent more than 1K in total on food orders.
-- return customer_name, and customer_id;

SELECT C.customer_name, 
SUM(O.total_amount) as Toatal_spent
FROM ORDERS as O
JOIN CUSTOMERS AS C 
ON C.customer_id=O.customer_id
GROUP BY 1
having SUM(O.total_amount)>1000;



--Q.5 Orders Without Delivery
-- Questions: Write a query to find orders that were placed but not delivered.
-- Return each restaurant name, city and number of not delivered orders

SELECT R.restaurant_id, R.restaurant_name, COUNT(O.order_id) as count_not_deliverd_order
FROM ORDERS AS O
LEFT JOIN RESTAURANTS AS R
ON R.restaurant_id=O.restaurant_id
LEFT JOIN
DELIVERY AS D
ON D.order_id=O.order_id
WHERE D.delivery_id IS NULL
GROUP BY 1
ORDER BY 2 DESC



--Q.6 Restaurant Revenue Ranking:
-- Rank restaurants by their total revenue from the last year, including their name,
-- total revenue, and rank within their city.

WITH ranking_table
AS(
SELECT R.city, R.restaurant_name, SUM(O.total_amount) AS revenue,
RANK() OVER(PARTITION BY R.city ORDER BY SUM(O.total_amount) DESC) AS RANK
FROM ORDERS AS O
JOIN RESTAURANTS AS R
ON R.restaurant_id=O.restaurant_id
WHERE O.order_date>= CURRENT_DATE-INTERVAL '1 YEAR'
GROUP BY 1, 2
)
SELECT * FROM ranking_table
WHERE RANK=1



--Q.7 Most Popular dish by city:
-- Identify the most popular dish in each city based on the number of orders.

SELECT * FROM 
(
SELECT R.city, O.order_item as dish,
COUNT(order_id) as total_orders,
RANK() OVER(PARTITION BY R.city Order by count(order_id) DESC) AS RANK
FROM ORDERS AS O
JOIN RESTAURANTS AS R
ON R.restaurant_id=O.restaurant_id
group by 1, 2
) as T1
where rank=1



--Q.8 Customer Churn:
-- Find customers who haven't placed an order in 2025 but did in 2024.
-- Find customer who has done order in 2023
-- Find customer who has not done order in 2024
-- compare 1 and 2

SELECT DISTINCT customer_id FROM ORDERS
WHERE
  EXTRACT(YEAR FROM order_date)=2024
AND customer_id NOT IN (SELECT customer_id FROM ORDERS
WHERE EXTRACT (YEAR FROM order_date)=2025)



--Q.9 Cancellation Rate Comparison
-- Calculate and compare the order cancellation rate for each restaurant between the
-- current year and the previous year.

WITH cancel_ratio_24
AS
(
SELECT O.restaurant_id, COUNT(O.order_id) AS total_orders,
COUNT(CASE WHEN D.delivery_id IS NULL THEN 1 END) AS not_delivered
FROM ORDERS AS O
LEFT JOIN DELIVERY AS D
ON O.order_id=D.order_id
WHERE EXTRACT(YEAR FROM O.order_date)=2024
GROUP BY O.restaurant_id
),
cancel_ratio_25 AS
(
SELECT O.restaurant_id, COUNT(O.order_id) AS total_orders,
COUNT(CASE WHEN D.delivery_id IS NULL THEN 1 END) AS not_delivered
FROM ORDERS AS O
LEFT JOIN DELIVERY AS D
ON O.order_id=D.order_id
WHERE EXTRACT(YEAR FROM O.order_date)=2025
GROUP BY O.restaurant_id
),
last_year_data AS
(
SELECT restaurant_id,
total_orders,
not_delivered, ROUND((not_delivered::numeric / total_orders::numeric)*100, 1) as cancel_ratio
FROM cancel_ratio_24
),
current_year_data AS 
(
SELECT restaurant_id,
total_orders,
not_delivered, ROUND((not_delivered::numeric / total_orders::numeric)*100, 1) as cancel_ratio
FROM cancel_ratio_25
)
SELECT C.restaurant_id AS restaurant_id,
C.cancel_ratio AS current_year_cancel_ratio,
L.cancel_ratio AS last_year_cancel_ratio
FROM current_year_data AS C
JOIN last_year_data AS L
ON C.restaurant_id=L.restaurant_id;



--Q.10 Rider Average Delivery Time:
-- Determine each rider's average delivery time.

SELECT O.order_id,
O.order_time,
D.delivery_time,
D.rider_id,
D.delivery_time-O.order_time AS time_difference,
EXTRACT(EPOCH FROM(D.delivery_time-O.order_time + 
CASE WHEN D.delivery_time<O.order_time THEN INTERVAL '1 DAY' ELSE
INTERVAL '0 DAY' END))/60 AS time_difference_insec
FROM ORDERS AS O
JOIN DELIVERY AS D
ON O.order_id=D.order_id
Where D.delivery_status='Delivered';



--Q.11 Monthly restaurant growth Ratio:
-- Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining

WITH growth_ratio AS
(
SELECT O.restaurant_id,
TO_CHAR(O.order_date, 'mm-yy') as month,
COUNT(O.order_id) as cr_month_orders,
LAG(COUNT(O.order_id),1) OVER(PARTITION BY O.restaurant_id ORDER BY TO_CHAR(O.order_date, 'mm-yy')) as prev_month_orders
FROM ORDERS AS O
JOIN DELIVERY AS D
ON O.order_id=D.order_id
WHERE D.delivery_status='Delivered'
GROUP BY 1,2
ORDER BY 1,2
)
SELECT restaurant_id,
MONTH, prev_month_orders, cr_month_orders
FROM growth_ratio



--Q.12 Customer Segmentation
-- Customer Segmentation: segment customers into 'gold' or 'silver' groups based on their total spending
-- Compared to the average order value (AOV). If a customer's total spending exceeds the AOV,
-- Label them as 'gold'; otherwise, label them as 'silver'. write an sql query to determine each segments
-- total number of orders and total revenue.

SELECT cx_category, SUM(total_orders) as total_orders,
SUM(total_spent) as total_revenue
FROM 
(SELECT customer_id, 
SUM(total_amount) as total_spent,
COUNT(order_id) as total_orders,
CASE
WHEN SUM(total_amount)>(SELECT AVG(total_amount) FROM orders) THEN 'Gold'
ELSE 'Silver'
END AS cx_category
FROM orders
GROUP BY 1)
AS T1
GROUP BY 1



--Q.13 Rider Monthly Earnings:
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the other amount.

SELECT D.rider_id,
TO_CHAR(O.order_date, 'mm-yy') as month,
SUM(total_amount) AS revenue,
SUM(total_amount)*0.08 as riders_earning
FROM ORDERS AS O
JOIN DELIVERY AS D
ON O.order_id=D.order_id
GROUP BY 1, 2
ORDER BY 1, 2



--Q.14 Rider ratings analysis:
-- Find the number of 5-star, 4-star, and 3-star ratings each rider has.
-- Riders receive this ratings based on delivery time.
-- If orders are delivered less than 15 minutes of order received time the rider get 5 star rating.
-- If they deliver 15 and 20 minute they get 4 star rating.
-- If they deliver after 20 minute they get 3 star rating.

SELECT rider_id, stars, COUNT(*) AS total_stars
FROM
(
SELECT rider_id, delivery_took_time,
CASE
WHEN delivery_took_time < 20 THEN '5 STAR'
WHEN delivery_took_time BETWEEN 20 AND 25 THEN '4 STAR'
ELSE '3 STAR'
END AS STARS
FROM
(
SELECT O.order_id, O.order_time, D.delivery_time,
EXTRACT(EPOCH FROM (D.delivery_time-O.order_time +
CASE WHEN D.delivery_time<O.order_time THEN INTERVAL '1 DAY'
ELSE INTERVAL '0 DAY' END))/60 AS delivery_took_time, D.rider_id
FROM ORDERS AS O
JOIN DELIVERY AS D
ON O.order_id=D.order_id
WHERE delivery_status='Delivered'
) AS T1)
AS T2
GROUP BY 1, 2
ORDER BY 1, 3 DESC



--Q.15 Order Frequency by Day:
-- Analyse order frequency per day of the week and identify the peak day for each restaurant.

SELECT *FROM
(
SELECT R.restaurant_name, 
TO_CHAR(O.order_date, 'Day') AS Day,
COUNT(O.order_id) AS total_orders,
RANK() OVER(PARTITION BY R.restaurant_name ORDER BY COUNT(O.order_id) DESC) AS RANK
FROM ORDERS AS O
JOIN RESTAURANTS AS R
ON O.restaurant_id=R.restaurant_id
GROUP BY 1, 2
ORDER BY 1, 3 DESC
) AS T1
WHERE RANK=1



--Q.16 Customer Lifetime value
-- Calculate the total revenue generated by each customer over all their orders.

SELECT O.customer_id, C.customer_name,
SUM(o.total_amount) AS CLV
FROM ORDERS AS O
JOIN CUSTOMERS AS C
ON O.customer_id=C.customer_id
GROUP BY 1, 2



--Q.17 Monthly sales trends:
-- Identify sales trends by comparing each months total sales to the previous month.

SELECT 
EXTRACT(YEAR FROM order_date) AS YEAR,
EXTRACT(MONTH FROM order_date) AS MONTH,
SUM(total_amount) AS total_sale,
LAG(SUM(total_amount), 1) OVER(ORDER BY EXTRACT(YEAR FROM order_date),
EXTRACT(MONTH FROM order_date)) AS prev_month_sale
FROM ORDERS
GROUP BY 1, 2



-- Q.18 Rider efficiency
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages.

WITH new_table
AS
(
SELECT *,
D.rider_id AS riders_id,
EXTRACT(EPOCH FROM (D.delivery_time-O.order_time +
CASE WHEN D.delivery_time < O.order_time THEN INTERVAL '1 DAY' ELSE
INTERVAL '0 DAY' END))/60 AS time_deliver
FROM ORDERS AS O
JOIN DELIVERY AS D
ON O.order_id=D.order_id
WHERE D.delivery_status='Delivered'
),
riders_time
AS
(
SELECT riders_id,
AVG(time_deliver) avg_time
FROM new_table
GROUP BY 1
)
SELECT
MIN(avg_time),
MAX(avg_time)
FROM riders_time



-- Q.19 Order item popularity:
-- Track the popularity of specific order items over time and identify seasonal demand spikes.

SELECT order_item, seasons,
COUNT(order_id) AS total_orders
FROM
(
SELECT *, 
EXTRACT(MONTH FROM order_date) AS MONTH,
CASE
WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6  THEN 'SPRING'
WHEN EXTRACT(MONTH FROM order_date) > 6 AND
EXTRACT(MONTH FROM order_date) < 9 THEN 'SUMMER'
ELSE 'WINTER'
END AS SEASONS
FROM ORDERS
) AS T1
GROUP BY 1, 2
ORDER BY 1, 3 DESC



-- Q.20 Monthly restaurant growth ratio:
-- Calculate each restaurants growth ratio based on the total amount of delivered orders since its joining

SELECT R.city,
SUM(total_amount) AS total_revenue,
RANK() OVER(ORDER BY SUM(total_amount) DESC) AS city_rank
FROM ORDERS AS O
JOIN RESTAURANTS AS R
ON O.restaurant_id=R.restaurant_id
GROUP BY 1








