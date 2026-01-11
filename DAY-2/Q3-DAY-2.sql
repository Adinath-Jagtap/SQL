-- 3. Count total employees per department
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id;