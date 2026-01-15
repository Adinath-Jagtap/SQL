-- Compare rows within the same table
-- Show each employee with their manager's name
SELECT
    e.name AS employee,
    m.name AS manager
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.emp_id;