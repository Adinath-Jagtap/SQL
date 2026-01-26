-- 1) Find the n-th highest salary (using DENSE_RANK to handle ties)
-- Set n to the desired rank (e.g., replace 2 with the rank you want)
WITH ranked AS (
  SELECT salary,
         DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
  FROM employees
)
SELECT salary AS nth_highest_salary
FROM ranked
WHERE rnk = 2;  -- <-- change 2 to your desired n