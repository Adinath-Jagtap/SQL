-- Select employees hired in the last 6 months
SELECT *
FROM employees
WHERE hire_date >= DATE('now', '-6 months');