-- 1) Find customers who placed orders in both 2024 and 2025
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2024 THEN 1 ELSE 0 END) > 0
   AND SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2025 THEN 1 ELSE 0 END) > 0;
