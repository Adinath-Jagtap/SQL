-- 9) Recursive CTE (generate numbers 1..10)
-- Note: use WITH RECURSIVE for SQLite/Postgres
WITH RECURSIVE nums(n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM nums WHERE n < 10
)
SELECT n FROM nums;
