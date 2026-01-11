-- 7. HAVING: regions with total sales > 10000
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region
HAVING SUM(amount) > 10000;