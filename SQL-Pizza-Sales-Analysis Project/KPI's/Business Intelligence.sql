/*
====================================================================
PIZZA SALES PERFORMANCE & OPERATIONAL TRENDS ANALYSIS
====================================================================
Description:
This script contains analytical queries designed to feed a business 
intelligence dashboard. It covers demand patterns (daily and hourly 
trends), sales mix by category and size, and product performance 
rankings (top and bottom selling pizzas).
====================================================================
*/

-- Daily Trend for Total Orders
SELECT DAYNAME(order_date) AS order_day,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DAYNAME(order_date), WEEKDAY(order_date)
ORDER BY WEEKDAY(order_date);

-- Hourly Trend for total orders
SELECT HOUR(order_time) AS order_per_hour,
	COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time); 

-- Percentage of sales by pizza Category
SELECT pizza_category,
	CONCAT(ROUND(SUM(total_price) * 100 / 
    (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1), 2), '%') AS percentage_of_sales,
    ROUND(SUM(total_price),0) AS total_sales
FROM pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY (pizza_category);

-- Percentage of sales by Pizza Size
SELECT pizza_size,
	ROUND(SUM(total_price),0) AS total_sales,
	CONCAT(ROUND(SUM(total_price) * 100 / 
    (SELECT SUM(total_price) FROM pizza_sales WHERE QUARTER(order_date) = 1), 2), '%') AS percentage_of_sales
FROM pizza_sales
WHERE QUARTER(order_date) = 1
GROUP BY (pizza_size)
ORDER BY pizza_size DESC;

-- Total pizzas sold by pizza category
SELECT pizza_category,
	CONCAT(SUM(quantity), '$') AS total_pizza_sold
FROM pizza_sales
GROUP BY pizza_category;

-- Top 5 Best sellers by Total Pizza Sold
SELECT ROW_NUMBER() OVER (ORDER BY SUM(quantity) DESC) AS rank_num,
	pizza_name,
	SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY (total_pizzas_sold) DESC
LIMIT 5;

-- Bottom 5 Worst seller by total Pizza Sold
SELECT ROW_NUMBER() OVER (ORDER BY SUM(quantity) ASC) AS rank_num,
	pizza_name,
	SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY (total_pizzas_sold) ASC
LIMIT 5;
