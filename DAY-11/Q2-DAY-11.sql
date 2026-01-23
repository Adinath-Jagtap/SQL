-- 2) Calculate running total of sales by date
-- Schema (example)
-- CREATE TABLE sales (sale_id INTEGER PRIMARY KEY, sale_date DATE, amount NUMERIC);

-- If you want running total on each row ordered by sale_date (and sale_id to break ties)
SELECT
  sale_id,
  sale_date,
  amount,
  SUM(amount) OVER (ORDER BY sale_date, sale_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM sales
ORDER BY sale_date, sale_id;

-- If you prefer one row per date (date-level aggregation first, then running total):
WITH daily AS (
  SELECT sale_date, SUM(amount) AS daily_amount
  FROM sales
  GROUP BY sale_date
)
SELECT
  sale_date,
  daily_amount,
  SUM(daily_amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_by_date
FROM daily
ORDER BY sale_date;