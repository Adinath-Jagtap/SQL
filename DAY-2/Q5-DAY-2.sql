-- 5. Max and Min salary per department
SELECT d.dept_name,
       MAX(e.salary) AS max_salary,
       MIN(e.salary) AS min_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;