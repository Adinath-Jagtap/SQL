-- Example assumes a hire_date column exists
-- Extract year and add 1 year to date
SELECT
    name,
    hire_date,
    EXTRACT(YEAR FROM hire_date) AS join_year,
    hire_date + INTERVAL '1 year' AS next_year_date
FROM employees;
