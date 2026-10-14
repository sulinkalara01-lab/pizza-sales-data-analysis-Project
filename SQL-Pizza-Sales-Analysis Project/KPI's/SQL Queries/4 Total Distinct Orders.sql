SELECT 	IFNULL(pizza_category, 'Total') AS pizza_category,
    COUNT(DISTINCT order_id) AS total_orders_per_category
FROM pizza_sales
GROUP BY ROLLUP (pizza_category);
