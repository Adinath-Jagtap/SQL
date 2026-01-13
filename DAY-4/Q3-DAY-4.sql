-- Similar to RANK, but does not skip numbers when salaries are equal
SELECT
    emp_id,
    name,
    dept_id,
    salary,
    DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dense_rank
FROM employees;
