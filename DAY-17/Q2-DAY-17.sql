-- 2) Calculate median salary by department (works in engines with window functions)
WITH ranked AS (
  SELECT dept_id,
         salary,
         ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary) AS rn,
         COUNT(*)     OVER (PARTITION BY dept_id) AS cnt
  FROM employees
)
SELECT dept_id,
       ROUND(AVG(salary)::numeric, 2) AS median_salary
FROM ranked
-- pick middle row(s). For odd cnt both expressions equal same rn, AVG returns that value.
WHERE rn IN ( (cnt + 1) / 2, (cnt + 2) / 2 )
GROUP BY dept_id
ORDER BY dept_id;
