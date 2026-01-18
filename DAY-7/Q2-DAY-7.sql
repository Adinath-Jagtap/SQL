-- Find departments where average salary > 50000
SELECT dept_name
FROM departments
WHERE dept_id IN (
    SELECT dept_id
    FROM employees
    GROUP BY dept_id
    HAVING AVG(salary) > 50000
);
