-- Find common text values between employee names and department names
SELECT name FROM employees
INTERSECT
SELECT dept_name FROM departments;