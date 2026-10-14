SELECT IFNULL(pizza_category, 'Total') AS pizza_category,
	SUM(quantity) AS total_of_unit_sold_per_category
FROM pizza_sales
GROUP BY ROLLUP (pizza_category);
		
