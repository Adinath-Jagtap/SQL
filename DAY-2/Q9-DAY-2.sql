-- 9. Count distinct employees per region
SELECT region, COUNT(DISTINCT emp_id) AS unique_employees
FROM sales
GROUP BY region;