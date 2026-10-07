USE restaurant_db; 

SELECT 
COUNT(*)
FROM menu_items;

SELECT 
COUNT(*)
FROM order_details;

-- join tables -- 
SELECT od.order_details_id,
       od.order_id,
       od.order_date,
       od.order_time,
       mi.item_name,
       mi.category,
       mi.price
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id; 

-- Doing the data analysis in 3 parts -- 
-- Part 1 - Explore the menu -- 
SELECT 
	COUNT(*)
FROM order_details od 
INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id ;

-- how many items and how are they spread across categoires ? 
SELECT 
	category,
    COUNT(*) AS num_items,
    ROUND(AVG(price),2) AS avg_price  
FROM menu_items
GROUP BY category;

-- most and least expensive items ?

SELECT *
FROM menu_items
ORDER BY price ASC 
LIMIT 1;

SELECT *
FROM menu_items
ORDER BY price DESC
LIMIT 1;



-- Part 2 - Explore the orders -- 
-- data range, number of orders, numbers of items sold. 
SELECT 
	MIN(order_date) AS min_orderdate, 
    MAX(order_date) AS max_orderdate,
    COUNT(DISTINCT order_id) AS total_orders, -- unique orders  -- 5370 
    COUNT(item_id) AS total_items -- total items by one order  -- 12097
FROM order_details;

-- orders with the most items  
SELECT 
	order_id,
	COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id 
ORDER BY num_items DESC
LIMIT 10;  -- largerst order has 14 items 

--  how many orders has more than 12 items?

SELECT COUNT(*) AS orders_morethan12items -- need to give name to output column 
FROM (
SELECT 
	order_id 
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) >12 
) AS morethan12items;  -- 20 -- need to give name to subquery table

-- Part 3 Combine the tables for business insight -- 
-- JOINED two tables -- TO find out best and worst selling items 
SELECT 
item_name,
category,
COUNT(*) AS times_ordered
FROM order_details  od 
INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY times_ordered DESC;  -- Hamburger 622 times, Chicken Tacos 123 


-- REVENUE by category 
SELECT 
category, 
SUM(price) AS revenue,
COUNT(*) AS items_sold
FROM order_details od
INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY category;
-- ORDER BY revenue DESC;  -- asian food is most sold, american food less sold 


-- TOP 5 highest-spend orders 
SELECT 
order_id,
SUM(price) AS total_spend
FROM order_details od
INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5; -- order_id  440with  total price 192.15 

SELECT *
FROM order_details od
INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id = 440; -- to check the items bought together . 

-- what cuisines do the top 5 orders buy ? -- 

WITH top_orders AS (
	SELECT order_id
	FROM order_details od
	INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
	GROUP BY order_id
	ORDER BY SUM(price) DESC 
	LIMIT 5
) 
SELECT 
od.order_id,
category,
COUNT(*) AS num_items
FROM order_details od
INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE od.order_id IN (SELECT order_id FROM top_orders)
GROUP BY od.order_id, category; --  Order 330: Asian (6), Mexican (4), Italian (3), American (1)Order 440: Italian (8), Mexican (2), American (2), Asian (2)Order 1957: Italian (5), Asian (3), American (3), Mexican (3)Order 2075: Italian (6), Asian (3), Mexican (3), American (1)Order 2675: Italian (4), Mexican (4), American (3), Asian (3)


-- Part 4 Advanced queries -- 
-- Busiest hour -- 
SELECT 
hour(order_time) AS hr, 
count(DISTINCT order_id) AS orders
FROM order_details
GROUP BY hr
ORDER BY orders DESC; -- 12PM 

-- Busiest Day -- 
SELECT 
dayname(order_time) AS day , 
count(DISTINCT order_id) AS orders
FROM order_details
GROUP BY day
ORDER BY orders DESC;  -- Saturday -- 


-- top earner 
SELECT mi.item_name, mi.price,
       COUNT(*) AS times_ordered,
       SUM(mi.price) AS revenue
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.price
ORDER BY revenue DESC
LIMIT 5;


-- monthly revenue growth -- 
WITH monthly AS (
  SELECT MONTH(order_date) AS m, SUM(price) AS revenue
  FROM order_details od
  JOIN menu_items mi ON od.item_id = mi.menu_item_id
  GROUP BY m
)
SELECT m, revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY m))
             / LAG(revenue) OVER (ORDER BY m) * 100, 1) AS growth_pct
FROM monthly;




-- percent of total revenue by category 
SELECT mi.category,
       SUM(mi.price) AS revenue,
       ROUND(SUM(mi.price) / SUM(SUM(mi.price)) OVER () * 100, 1) AS pct_of_total
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.category
ORDER BY revenue DESC;


