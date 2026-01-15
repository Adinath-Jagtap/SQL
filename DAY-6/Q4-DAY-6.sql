-- Combine employee names and department names (unique)
SELECT name AS value FROM employees
UNION
SELECT dept_name FROM departments;
