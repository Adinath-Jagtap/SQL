-- Same as UNION but keeps duplicates
SELECT name AS value FROM employees
UNION ALL
SELECT dept_name FROM departments;
