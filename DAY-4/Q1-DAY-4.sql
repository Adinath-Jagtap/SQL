-- Assigns a unique sequential number to each row
-- Rows are ordered by salary in descending order
SELECT
    emp_id,
    name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM employees;