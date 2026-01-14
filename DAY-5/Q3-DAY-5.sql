-- 3) Update salary for the employee with emp_id = 3
-- Only the matching row will be updated
UPDATE employees
SET salary = 37000, city = 'Pune'  -- example: increase salary and set city
WHERE emp_id = 3;

-- Show the updated row to verify
SELECT 'STEP 3: Updated row (emp_id=3)' AS step, * FROM employees WHERE emp_id = 3;
