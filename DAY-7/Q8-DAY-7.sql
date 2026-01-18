-- Replace NULL manager_id with 0
-- Avoid division by zero using NULLIF
SELECT
    name,
    COALESCE(manager_id, 0) AS safe_manager_id,
    salary / NULLIF(salary, 0) AS safe_division_example
FROM employees;
