-- =============================================================================
-- SQL PRACTICE QUESTIONS - JOINS, AGGREGATION & WINDOWS
-- =============================================================================
/*
1. Join three tables and filter results
   - Perform JOINs across table_a, table_b, table_c with appropriate ON conditions and apply WHERE filters.

2. Find customers with multiple orders using GROUP BY + HAVING
   - GROUP BY customer_id HAVING COUNT(order_id) > 1 to list customers with more than one order.

3. Use a window function to find difference from previous row
   - Use LAG() or ROWS BETWEEN to compute value - LAG(value) OVER (ORDER BY date_column) for each row.
*/