-- 2) Count employees in each department
SELECT dept_id, COUNT(*) AS employee_count
FROM employees
GROUP BY dept_id
ORDER BY dept_id;
