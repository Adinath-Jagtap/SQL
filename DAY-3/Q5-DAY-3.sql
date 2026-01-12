-- 5) Use IN with subquery to match multiple values (dept ids from departments)
SELECT e.*
FROM employees e
WHERE e.dept_id IN (
  SELECT dept_id
  FROM departments
  WHERE dept_name LIKE 'S%'   -- e.g. departments starting with S
);
