-- Computes average of current row and previous 2 rows (window size = 3)
SELECT
    emp_id,
    name,
    hire_date,
    salary,
    AVG(salary) OVER (
        ORDER BY hire_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM employees
ORDER BY hire_date;
