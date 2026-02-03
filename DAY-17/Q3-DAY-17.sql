-- 3) Find gaps in sequential IDs (missing ids) using a recursive CTE
-- Replace 'mytable' and 'id' with your table & id column names
WITH RECURSIVE seq(n) AS (
  SELECT (SELECT MIN(id) FROM mytable)
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < (SELECT MAX(id) FROM mytable)
)
SELECT seq.n AS missing_id
FROM seq
LEFT JOIN mytable t ON t.id = seq.n
WHERE t.id IS NULL
ORDER BY seq.n;
