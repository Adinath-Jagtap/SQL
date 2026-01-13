-- LEAD gives value from the next row based on ordering
SELECT
    emp_id,
    name,
    salary,
    LEAD(salary, 1) OVER (ORDER BY salary) AS next_salary
FROM employees
ORDER BY salary;
