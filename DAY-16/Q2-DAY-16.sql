-- 2) Calculate year-over-year growth percentage (2025 vs 2024 total sales)
WITH yearly AS (
  SELECT EXTRACT(YEAR FROM order_date) AS yr,
         SUM(amount) AS total_sales
  FROM orders
  GROUP BY EXTRACT(YEAR FROM order_date)
)
SELECT
  y2024.total_sales AS sales_2024,
  y2025.total_sales AS sales_2025,
  CASE
    WHEN y2024.total_sales = 0 THEN NULL
    ELSE ROUND((y2025.total_sales - y2024.total_sales) / y2024.total_sales * 100, 2)
  END AS yoy_growth_pct
FROM yearly y2024
JOIN yearly y2025 ON y2025.yr = y2024.yr + 1
WHERE y2024.yr = 2024;  -- shows growth from 2024 -> 2025
