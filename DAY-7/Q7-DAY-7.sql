-- Use CONCAT, SUBSTRING, and UPPER
SELECT
    CONCAT(UPPER(SUBSTRING(name, 1, 1)), SUBSTRING(name, 2)) AS formatted_name,
    CONCAT(name, ' works in ', d.dept_name) AS info
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
