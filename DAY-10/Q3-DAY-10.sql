-- Group employees by dept_id and filter groups having count > 5.
-- If you have a departments table and want department names:
SELECT d.dept_id, d.dept_name, sub.cnt
FROM (
  SELECT dept_id, COUNT(*) AS cnt
  FROM employees
  GROUP BY dept_id
  HAVING COUNT(*) > 5
) AS sub
JOIN departments d ON d.dept_id = sub.dept_id;

-- Or simple list of dept_ids:
-- SELECT dept_id FROM employees GROUP BY dept_id HAVING COUNT(*) > 5;
