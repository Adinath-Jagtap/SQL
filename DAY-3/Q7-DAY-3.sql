-- 7) Simple CTE: compute dept averages, then select high-paying departments
WITH dept_avg AS (
  SELECT dept_id, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY dept_id
)
SELECT d.dept_id, d.avg_salary
FROM dept_avg d
WHERE d.avg_salary > 45000;
