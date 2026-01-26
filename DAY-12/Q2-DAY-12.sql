-- 2) Employees who earn more than the average salary in their department
-- Join employees to a derived table that holds dept average salary
SELECT e.emp_id,
       e.name,
       e.dept_id,
       e.salary,
       a.avg_salary
FROM employees e
JOIN (
  SELECT dept_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY dept_id
) AS a
  ON e.dept_id = a.dept_id
WHERE e.salary > a.avg_salary;