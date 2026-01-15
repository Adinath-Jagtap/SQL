-- Join employees with a subquery that calculates average salary per department
SELECT
    e.name,
    e.salary,
    avg_tbl.avg_salary
FROM employees e
JOIN (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
) AS avg_tbl
ON e.dept_id = avg_tbl.dept_id;
