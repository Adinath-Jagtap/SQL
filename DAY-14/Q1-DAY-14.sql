-- 1) Join 3 tables and filter results
-- Example: orders JOIN customers JOIN products, show orders for product category 'Electronics' in 2025
SELECT o.order_id, o.order_date, c.customer_id, c.name AS customer_name,
       p.product_id, p.product_name, p.category, oi.quantity, oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Electronics' AND o.order_date BETWEEN '2025-01-01' AND '2025-12-31';