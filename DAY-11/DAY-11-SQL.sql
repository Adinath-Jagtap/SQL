-- =============================================================================
-- SQL FINAL PROBLEMS (3)
-- =============================================================================
/*
1. Find customers who never ordered
   - Return customers from the customers table with no matching records in the orders table (LEFT JOIN / NOT EXISTS).

2. Calculate running total of sales by date
   - Use a window function to compute cumulative SUM(sales) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW).

3. Find top 3 products by revenue in each category
   - Use RANK()/ROW_NUMBER() partitioned by category ordered by revenue DESC and filter to keep top 3 per category.
*/
