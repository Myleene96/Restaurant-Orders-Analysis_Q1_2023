# Restaurant Orders Analysis (MySQL)

# Business Problem
Taste of the World Café launched a new menu in Jan 2023. 
I analyzed Q1 order data to find top/bottom items, revenue drivers, and peak times.

## Dataset
2 tables: menu_items (32 items), order_details (12,234 rows, 5,370 orders)
Source: [Maven](https://mavenanalytics.io/data-playground/restaurant-orders) 

## Data Cleaning
- 137 rows had NULL item_id (1.1%). Excluded from item/revenue analysis.

## Key Insights
1. Hamburger (622) and Edamame (620) are the most ordered items.
2. Chicken Tacos (123) is by far the least ordered, so it's a removal candidate.
3. Italian earns the most revenue ($49.5K) despite fewer orders than Asian.
4. Top 5 highest-spend orders are mostly Italian, so high spenders prefer Italian.
5. Average order value: $29.80

## Recommendations
- Keep and promote Italian dishes
- Remove or rework Chicken Tacos
- Review the Mexican menu (4 of the bottom 6 items)

## Skills Used
JOINs, GROUP BY, aggregate functions, CTEs, subqueries, window functions

## Dashboard
![dashboard](SALES_Dashboard.png)
