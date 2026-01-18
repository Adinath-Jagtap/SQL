-- Categorize employees based on salary
SELECT
    name,
    salary,
    CASE
        WHEN salary >= 60000 THEN 'High'
        WHEN salary >= 45000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_level
FROM employees;
