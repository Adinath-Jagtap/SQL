-- 5) Add a new column 'email' to the employees table
-- In SQLite and many engines you can add a column with ALTER TABLE ... ADD COLUMN
ALTER TABLE employees
ADD COLUMN email TEXT;  -- new column will be NULL for existing rows

-- Optionally populate the new column for existing rows
UPDATE employees
SET email = CASE
    WHEN emp_id = 1 THEN 'amit@example.com'
    WHEN emp_id = 2 THEN 'riya@example.com'
    WHEN emp_id = 4 THEN 'sneha@example.com'
    WHEN emp_id = 5 THEN 'arjun@example.com'
    ELSE NULL
END;

-- Verify table structure and sample data
-- (In SQLite metadata lives in sqlite_master; in other DBs use information_schema)
SELECT 'STEP 5: Table rows with new column' AS step, * FROM employees ORDER BY emp_id;
