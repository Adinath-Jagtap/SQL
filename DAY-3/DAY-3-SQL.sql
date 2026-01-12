-- ============================================================================
-- SQL SUBQUERIES & CTEs - BEGINNER'S GUIDE
-- ============================================================================

-- ============================================================================
-- SECTION 1: WHAT ARE SUBQUERIES?
-- ============================================================================

/*
SUBQUERY (also called a NESTED QUERY or INNER QUERY):
- A query inside another query
- Executes first, then the outer query uses its result
- Always enclosed in parentheses ()
- Think of it as a "query within a query"

WHY USE SUBQUERIES?
- Break complex problems into smaller steps
- Filter data based on calculations from other data
- Compare values against aggregated results
- Make queries more readable and logical

BASIC STRUCTURE:
    SELECT columns
    FROM table
    WHERE column operator (SELECT column FROM table WHERE condition);
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                          This is the subquery
*/


-- ============================================================================
-- SECTION 2: SUBQUERY IN WHERE CLAUSE
-- ============================================================================

/*
Most common type of subquery
Used to filter rows based on results from another query
*/

-- ----------------------------------------------------------------------------
-- 2.1 Basic Subquery with Comparison Operators
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Find employees who earn more than the average salary

THINKING PROCESS:
Step 1: What's the average salary? (subquery)
Step 2: Show employees earning more than that (outer query)
*/

SELECT emp_id, name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                Subquery returns a single value (the average)

/*
HOW IT WORKS:
1. Subquery runs first: SELECT AVG(salary) FROM employees → returns 50000
2. Outer query runs: SELECT ... WHERE salary > 50000
*/


-- ----------------------------------------------------------------------------
-- 2.2 Subquery with IN Operator
-- ----------------------------------------------------------------------------

/*
IN is used when the subquery returns multiple values

EXAMPLE: Find employees in departments located in 'New York'

THINKING PROCESS:
Step 1: Which departments are in New York? (subquery)
Step 2: Show employees in those departments (outer query)
*/

SELECT emp_id, name, dept_id
FROM employees
WHERE dept_id IN (SELECT dept_id 
                  FROM departments 
                  WHERE location = 'New York');
                  
/*
HOW IT WORKS:
1. Subquery returns: (10, 20, 30)  -- dept_ids in New York
2. Outer query becomes: WHERE dept_id IN (10, 20, 30)
*/

-- You can also use NOT IN to exclude values:
SELECT emp_id, name, dept_id
FROM employees
WHERE dept_id NOT IN (SELECT dept_id 
                      FROM departments 
                      WHERE location = 'New York');


-- ----------------------------------------------------------------------------
-- 2.3 Subquery with EXISTS
-- ----------------------------------------------------------------------------

/*
EXISTS checks if the subquery returns any rows
- Returns TRUE if subquery has results
- Returns FALSE if subquery is empty
- More efficient than IN for large datasets
*/

-- Find departments that have at least one employee:
SELECT dept_id, dept_name
FROM departments d
WHERE EXISTS (SELECT 1 
              FROM employees e 
              WHERE e.dept_id = d.dept_id);
              
/*
EXISTS just checks for existence, doesn't care about actual values
That's why we use "SELECT 1" - we only need to know if rows exist
*/


-- ============================================================================
-- SECTION 3: SUBQUERY IN SELECT CLAUSE
-- ============================================================================

/*
Subquery in SELECT clause:
- Returns a single value for each row
- Also called a SCALAR SUBQUERY
- Must return exactly one value (one row, one column)
*/

-- ----------------------------------------------------------------------------
-- 3.1 Adding Calculated Values to Each Row
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Show each employee with the company's average salary
*/

SELECT emp_id,
       name,
       salary,
       (SELECT AVG(salary) FROM employees) AS company_avg_salary,
       salary - (SELECT AVG(salary) FROM employees) AS difference_from_avg
FROM employees;

/*
RESULT EXAMPLE:
emp_id | name  | salary | company_avg_salary | difference_from_avg
1      | Alice | 60000  | 50000              | 10000
2      | Bob   | 45000  | 50000              | -5000
3      | Carol | 55000  | 50000              | 5000

Each row shows how that employee compares to the average
*/


-- ----------------------------------------------------------------------------
-- 3.2 Subquery with Aggregates per Row
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Show each department with its employee count
*/

SELECT dept_id,
       dept_name,
       (SELECT COUNT(*) 
        FROM employees e 
        WHERE e.dept_id = d.dept_id) AS employee_count
FROM departments d;

/*
NOTE: This is similar to a correlated subquery (explained later)
The subquery references the outer query's table (d.dept_id)
*/


-- ============================================================================
-- SECTION 4: SUBQUERY IN FROM CLAUSE (Derived Table)
-- ============================================================================

/*
Subquery in FROM clause:
- Creates a temporary result set (derived table)
- Must have an alias (AS something)
- Treated like a regular table in the outer query
- Great for breaking complex logic into steps
*/

-- ----------------------------------------------------------------------------
-- 4.1 Basic Derived Table
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Find average salary by department, then only show departments 
         where average is above 50000
*/

-- Step 1: Create derived table with averages
SELECT dept_id, avg_salary
FROM (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
) AS dept_averages              -- Must give it an alias!
WHERE avg_salary > 50000;

/*
HOW IT WORKS:
1. Inner query creates a temporary table with dept_id and avg_salary
2. Outer query filters that temporary table
*/


-- ----------------------------------------------------------------------------
-- 4.2 Complex Derived Table Example
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Find the top 3 highest-paid employees in each department
*/

-- First, get all employees with their department rank:
SELECT emp_id, name, dept_id, salary, salary_rank
FROM (
    SELECT emp_id, 
           name, 
           dept_id, 
           salary,
           ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
    FROM employees
) AS ranked_employees
WHERE salary_rank <= 3;

/*
This uses window functions (ROW_NUMBER) which you'll learn later
The key point: we create a derived table with rankings, then filter it
*/


-- ----------------------------------------------------------------------------
-- 4.3 Joining Derived Tables
-- ----------------------------------------------------------------------------

/*
You can join derived tables with regular tables
*/

SELECT d.dept_name, summary.total_salary, summary.employee_count
FROM departments d
INNER JOIN (
    SELECT dept_id, 
           SUM(salary) AS total_salary,
           COUNT(*) AS employee_count
    FROM employees
    GROUP BY dept_id
) AS summary
ON d.dept_id = summary.dept_id;


-- ============================================================================
-- SECTION 5: CORRELATED SUBQUERIES
-- ============================================================================

/*
CORRELATED SUBQUERY:
- References columns from the outer query
- Executes once for EACH row of the outer query
- Generally slower than non-correlated subqueries
- Very powerful for row-by-row comparisons

DIFFERENCE:
- Non-correlated: Runs once, returns result, outer query uses it
- Correlated: Runs multiple times (once per outer row)
*/

-- ----------------------------------------------------------------------------
-- 5.1 Basic Correlated Subquery
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Find employees who earn more than the average in THEIR department
*/

SELECT e1.emp_id, e1.name, e1.dept_id, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id  -- References outer query!
);

/*
HOW IT WORKS:
For each employee (e1):
1. Subquery calculates average salary for that employee's department
2. Compares that employee's salary to their department average
3. If higher, includes that row

For Alice in dept 10:
  - Subquery finds AVG salary in dept 10
  - Compares Alice's salary to that average
  
For Bob in dept 20:
  - Subquery finds AVG salary in dept 20
  - Compares Bob's salary to that average
  
And so on...
*/


-- ----------------------------------------------------------------------------
-- 5.2 Correlated Subquery with EXISTS
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Find departments that have at least one employee earning > 60000
*/

SELECT d.dept_id, d.dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.dept_id = d.dept_id 
    AND e.salary > 60000
);

/*
For each department:
- Check if any employee in that department earns > 60000
- If yes, include that department
*/


-- ----------------------------------------------------------------------------
-- 5.3 Correlated Subquery in SELECT
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Show each department with its highest salary
*/

SELECT dept_id,
       dept_name,
       (SELECT MAX(e.salary)
        FROM employees e
        WHERE e.dept_id = d.dept_id) AS max_salary_in_dept
FROM departments d;


-- ============================================================================
-- SECTION 6: COMMON TABLE EXPRESSIONS (CTEs)
-- ============================================================================

/*
CTE (Common Table Expression):
- Named temporary result set
- Exists only during query execution
- More readable than subqueries
- Can be referenced multiple times in the same query
- Defined using WITH keyword

BENEFITS:
✓ More readable and maintainable
✓ Can reference the CTE multiple times
✓ Easier to debug (test each CTE separately)
✓ Better for complex queries
✓ Required for recursive queries

SYNTAX:
    WITH cte_name AS (
        SELECT ...
    )
    SELECT ... FROM cte_name;
*/


-- ----------------------------------------------------------------------------
-- 6.1 Simple CTE
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Same as earlier, but using CTE instead of subquery
Find employees earning more than average
*/

-- Using subquery (what we did before):
SELECT emp_id, name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Using CTE (cleaner!):
WITH avg_salary_cte AS (
    SELECT AVG(salary) AS average_salary
    FROM employees
)
SELECT emp_id, name, salary
FROM employees, avg_salary_cte
WHERE salary > avg_salary_cte.average_salary;

/*
ADVANTAGES:
- CTE has a name (avg_salary_cte) - self-documenting!
- Can reference avg_salary_cte multiple times if needed
- Easier to read and understand
*/


-- ----------------------------------------------------------------------------
-- 6.2 CTE for Department Summaries
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Calculate department statistics, then use them
*/

WITH dept_stats AS (
    SELECT dept_id,
           COUNT(*) AS employee_count,
           AVG(salary) AS avg_salary,
           MAX(salary) AS max_salary,
           MIN(salary) AS min_salary
    FROM employees
    GROUP BY dept_id
)
SELECT d.dept_name,
       ds.employee_count,
       ds.avg_salary,
       ds.max_salary
FROM departments d
INNER JOIN dept_stats ds ON d.dept_id = ds.dept_id
WHERE ds.avg_salary > 50000;

/*
READING THIS QUERY:
1. "WITH dept_stats AS" - Create a temporary result called dept_stats
2. First SELECT creates the dept_stats with aggregated data
3. Second SELECT uses dept_stats just like a regular table
*/


-- ============================================================================
-- SECTION 7: MULTIPLE CTEs
-- ============================================================================

/*
You can define multiple CTEs in one query
Separate them with commas (NOT with multiple WITH keywords)

SYNTAX:
    WITH 
        cte1 AS (SELECT ...),
        cte2 AS (SELECT ...),
        cte3 AS (SELECT ...)
    SELECT ... FROM cte1 JOIN cte2 ...;
*/

-- ----------------------------------------------------------------------------
-- 7.1 Multiple CTEs Example
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Compare high performers across departments
*/

WITH 
-- CTE 1: Calculate average salary per department
dept_averages AS (
    SELECT dept_id, AVG(salary) AS avg_dept_salary
    FROM employees
    GROUP BY dept_id
),

-- CTE 2: Find employees earning above their department average
high_earners AS (
    SELECT e.emp_id, e.name, e.dept_id, e.salary
    FROM employees e
    INNER JOIN dept_averages da ON e.dept_id = da.dept_id
    WHERE e.salary > da.avg_dept_salary
),

-- CTE 3: Count high earners per department
high_earner_counts AS (
    SELECT dept_id, COUNT(*) AS num_high_earners
    FROM high_earners
    GROUP BY dept_id
)

-- Final query: Show departments with their high earner count
SELECT d.dept_name, 
       hec.num_high_earners,
       da.avg_dept_salary
FROM departments d
LEFT JOIN high_earner_counts hec ON d.dept_id = hec.dept_id
LEFT JOIN dept_averages da ON d.dept_id = da.dept_id
ORDER BY hec.num_high_earners DESC;

/*
BREAKING IT DOWN:
1. dept_averages: What's the average salary in each department?
2. high_earners: Which employees beat their department's average?
3. high_earner_counts: How many high earners per department?
4. Final query: Put it all together with department names

Each CTE builds on previous results - like steps in a recipe!
*/


-- ----------------------------------------------------------------------------
-- 7.2 CTEs Referencing Other CTEs
-- ----------------------------------------------------------------------------

/*
Later CTEs can reference earlier CTEs
*/

WITH
-- Step 1: Get 2024 sales
sales_2024 AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM sales
    WHERE YEAR(sale_date) = 2024
    GROUP BY region_id
),

-- Step 2: Get top regions (uses sales_2024)
top_regions AS (
    SELECT region_id
    FROM sales_2024
    WHERE total_sales > 100000
)

-- Step 3: Show details for top regions
SELECT r.region_name, s.total_sales
FROM regions r
INNER JOIN sales_2024 s ON r.region_id = s.region_id
WHERE r.region_id IN (SELECT region_id FROM top_regions);


-- ============================================================================
-- SECTION 8: RECURSIVE CTEs
-- ============================================================================

/*
RECURSIVE CTE:
- A CTE that references itself
- Used for hierarchical or sequential data
- Common uses: organizational charts, family trees, number sequences
- Has two parts: base case (anchor) and recursive case

SYNTAX:
    WITH RECURSIVE cte_name AS (
        -- Base case (anchor member)
        SELECT ...
        
        UNION ALL
        
        -- Recursive case (recursive member)
        SELECT ... FROM cte_name ...
    )
    SELECT * FROM cte_name;

WARNING: Always include a condition to stop recursion (or it runs forever!)
*/

-- ----------------------------------------------------------------------------
-- 8.1 Simple Recursive CTE - Number Sequence
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Generate numbers from 1 to 10
*/

WITH RECURSIVE number_sequence AS (
    -- Base case: Start with 1
    SELECT 1 AS n
    
    UNION ALL
    
    -- Recursive case: Add 1 to previous number
    SELECT n + 1
    FROM number_sequence
    WHERE n < 10  -- Stop condition!
)
SELECT n FROM number_sequence;

/*
HOW IT WORKS:
Iteration 1: n = 1 (base case)
Iteration 2: n = 1 + 1 = 2
Iteration 3: n = 2 + 1 = 3
...
Iteration 10: n = 9 + 1 = 10
Iteration 11: n = 10, but 10 < 10 is FALSE, so stop

RESULT: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
*/


-- ----------------------------------------------------------------------------
-- 8.2 Recursive CTE - Employee Hierarchy
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Show organizational hierarchy (who reports to whom)

Table structure:
emp_id | name    | manager_id
1      | CEO     | NULL
2      | VP1     | 1
3      | VP2     | 1
4      | Mgr1    | 2
5      | Mgr2    | 2
6      | Emp1    | 4
*/

WITH RECURSIVE employee_hierarchy AS (
    -- Base case: Start with CEO (no manager)
    SELECT emp_id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: Find direct reports
    SELECT e.emp_id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.emp_id
)
SELECT emp_id, 
       REPEAT('  ', level - 1) || name AS name_indented,
       level
FROM employee_hierarchy
ORDER BY level, emp_id;

/*
RESULT:
emp_id | name_indented  | level
1      | CEO            | 1
2      |   VP1          | 2
3      |   VP2          | 2
4      |     Mgr1       | 3
5      |     Mgr2       | 3
6      |       Emp1     | 4

Shows the hierarchy visually!
*/


-- ----------------------------------------------------------------------------
-- 8.3 Recursive CTE - Path Finding
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Find all paths in a graph/network

Useful for:
- Flight connections (how to get from A to B with stops)
- Network routing
- Dependency chains
*/

WITH RECURSIVE flight_paths AS (
    -- Base case: Direct flights
    SELECT origin, destination, 1 AS num_stops, 
           CAST(origin || '->' || destination AS VARCHAR(1000)) AS path
    FROM flights
    WHERE origin = 'NYC'
    
    UNION ALL
    
    -- Recursive case: Connecting flights
    SELECT fp.origin, f.destination, fp.num_stops + 1,
           CAST(fp.path || '->' || f.destination AS VARCHAR(1000))
    FROM flight_paths fp
    INNER JOIN flights f ON fp.destination = f.origin
    WHERE fp.num_stops < 3  -- Max 3 stops
    AND fp.path NOT LIKE '%' || f.destination || '%'  -- Avoid cycles
)
SELECT * FROM flight_paths
WHERE destination = 'LAX'
ORDER BY num_stops;

/*
Finds all ways to get from NYC to LAX with up to 3 stops
Shows the path taken: NYC->Chicago->Denver->LAX
*/


-- ============================================================================
-- SECTION 9: CTEs WITH JOINS
-- ============================================================================

/*
CTEs work great with JOINs
You can join CTEs with regular tables or other CTEs
*/

-- ----------------------------------------------------------------------------
-- 9.1 CTE Joined with Regular Table
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Find departments with above-average employee count
*/

WITH dept_sizes AS (
    SELECT dept_id, COUNT(*) AS employee_count
    FROM employees
    GROUP BY dept_id
),
avg_size AS (
    SELECT AVG(employee_count) AS avg_count
    FROM dept_sizes
)
SELECT d.dept_name, 
       ds.employee_count,
       a.avg_count
FROM departments d
INNER JOIN dept_sizes ds ON d.dept_id = ds.dept_id
CROSS JOIN avg_size a
WHERE ds.employee_count > a.avg_count;


-- ----------------------------------------------------------------------------
-- 9.2 Multiple CTEs Joined Together
-- ----------------------------------------------------------------------------

/*
EXAMPLE: Compare sales and costs by region
*/

WITH 
sales_summary AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM sales
    WHERE YEAR(sale_date) = 2024
    GROUP BY region_id
),
cost_summary AS (
    SELECT region_id, SUM(amount) AS total_costs
    FROM costs
    WHERE YEAR(cost_date) = 2024
    GROUP BY region_id
)
SELECT r.region_name,
       s.total_sales,
       c.total_costs,
       s.total_sales - c.total_costs AS profit
FROM regions r
LEFT JOIN sales_summary s ON r.region_id = s.region_id
LEFT JOIN cost_summary c ON r.region_id = c.region_id;


-- ============================================================================
-- SECTION 10: WHEN TO USE WHAT?
-- ============================================================================

/*
SUBQUERY vs CTE - DECISION GUIDE:

USE SUBQUERY WHEN:
✓ Query is simple and only used once
✓ The nested query is very short
✓ You're comfortable with nested parentheses
Example: WHERE salary > (SELECT AVG(salary) FROM employees)

USE CTE WHEN:
✓ Query is complex or used multiple times
✓ You want better readability
✓ Query involves multiple steps
✓ You need recursion
✓ You're working with hierarchical data
Example: Building reports with multiple aggregation steps

CORRELATED SUBQUERY:
✓ When you need row-by-row comparisons
✓ When each row needs its own calculation
Warning: Can be slow on large datasets - consider JOINs or window functions instead

RECURSIVE CTE:
✓ Hierarchies (org charts, file systems)
✓ Graph traversal
✓ Sequential data generation
✓ Path finding
*/


-- ============================================================================
-- SECTION 11: PERFORMANCE TIPS
-- ============================================================================

/*
1. SUBQUERIES IN WHERE vs JOINs:
   - JOINs are often faster
   - Subqueries can be clearer for logic
   - Test both approaches on large datasets

2. CORRELATED SUBQUERIES:
   - Can be slow (runs once per row)
   - Consider alternatives:
     * JOIN with aggregate
     * Window functions
     * Regular subquery with JOIN

3. CTEs vs SUBQUERIES:
   - CTEs may be optimized differently by database
   - Some databases materialize CTEs (store temporarily)
   - Some databases inline CTEs (treat like subqueries)
   - Performance is usually similar

4. RECURSIVE CTEs:
   - Always include stop condition
   - Limit depth if possible
   - Can be slow on deep hierarchies
   - Add WHERE clauses to filter early

5. GENERAL TIPS:
   - Keep subqueries simple
   - Filter data early (in inner queries)
   - Use appropriate indexes
   - Test with EXPLAIN or query analyzer
*/


-- ============================================================================
-- QUICK REFERENCE CHEAT SHEET
-- ============================================================================

/*
SUBQUERY TYPES:

1. WHERE Clause:
   WHERE column > (SELECT AVG(column) FROM table)
   WHERE column IN (SELECT column FROM table WHERE ...)

2. SELECT Clause:
   SELECT column, (SELECT COUNT(*) FROM table2) AS count

3. FROM Clause:
   FROM (SELECT ... FROM table) AS alias

4. Correlated:
   WHERE col > (SELECT AVG(t2.col) FROM table t2 WHERE t2.id = t1.id)

CTE SYNTAX:

Single CTE:
   WITH cte_name AS (SELECT ...)
   SELECT * FROM cte_name;

Multiple CTEs:
   WITH 
       cte1 AS (SELECT ...),
       cte2 AS (SELECT ...)
   SELECT * FROM cte1 JOIN cte2 ...;

Recursive CTE:
   WITH RECURSIVE cte_name AS (
       SELECT ... -- base
       UNION ALL
       SELECT ... FROM cte_name WHERE ... -- recursive
   )
   SELECT * FROM cte_name;
*/


-- ============================================================================
-- COMMON BEGINNER MISTAKES
-- ============================================================================

/*
1. MISTAKE: Forgetting alias for derived table
   WRONG:   SELECT * FROM (SELECT dept_id FROM employees);
   RIGHT:   SELECT * FROM (SELECT dept_id FROM employees) AS sub;

2. MISTAKE: Using multiple WITH keywords
   WRONG:   WITH cte1 AS (...) WITH cte2 AS (...)
   RIGHT:   WITH cte1 AS (...), cte2 AS (...)

3. MISTAKE: Subquery returns multiple columns when expecting one
   WRONG:   WHERE salary > (SELECT emp_id, salary FROM employees)
   RIGHT:   WHERE salary > (SELECT MAX(salary) FROM employees)

4. MISTAKE: No stop condition in recursive CTE
   WRONG:   WITH RECURSIVE nums AS (SELECT 1 UNION ALL SELECT n+1 FROM nums)
   RIGHT:   WITH RECURSIVE nums AS (SELECT 1 UNION ALL SELECT n+1 FROM nums WHERE n<10)

5. MISTAKE: Correlated subquery without table aliases
   WRONG:   WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id=dept_id)
   RIGHT:   WHERE salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id=e1.dept_id)

6. MISTAKE: Trying to use CTE outside its query
   WRONG:   WITH cte AS (SELECT ...) SELECT * FROM table1; SELECT * FROM cte;
   RIGHT:   WITH cte AS (SELECT ...) SELECT * FROM cte JOIN table1 ...;
*/


-- ============================================================================
-- PRACTICE STRATEGY
-- ============================================================================

/*
DAY 3 PRACTICE PROGRESSION:

BEGINNER:
1. Start with simple WHERE subqueries
2. Practice IN and NOT IN with subqueries
3. Try basic CTEs (replace your subqueries with CTEs)
4. Compare readability: subquery vs CTE

INTERMEDIATE:
5. Write correlated subqueries
6. Create multiple CTEs in one query
7. Join CTEs with regular tables
8. Use CTEs in INSERT/UPDATE/DELETE

ADVANCED:
9. Build recursive CTEs for hierarchies
10. Optimize: compare subquery vs JOIN performance
11. Combine everything: CTEs + JOINs + WHERE + HAVING

TIPS:
- Start simple, then add complexity
- Test each subquery independently first
- Use CTEs to break complex queries into steps
- Draw diagrams for recursive CTEs
- Read execution plans to understand performance
*/