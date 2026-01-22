-- Self-join employees to compare employee salary with manager salary.
-- Excludes rows where manager_id is NULL (no manager).
SELECT e.emp_id, e.name AS employee_name, e.salary AS employee_salary,
       m.emp_id AS manager_id, m.name AS manager_name, m.salary AS manager_salary
FROM employees e
JOIN employees m
  ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;
