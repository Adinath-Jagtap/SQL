-- 10. JOIN + WHERE (sales in a date range)
SELECT e.name, s.region, s.amount, s.sale_date
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
WHERE s.sale_date BETWEEN '2025-01-01' AND '2025-01-15';