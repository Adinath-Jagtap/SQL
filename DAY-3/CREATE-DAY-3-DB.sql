-- sample tables for Day 3 examples
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT
);

CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY,
    name TEXT,
    salary INTEGER,
    dept_id INTEGER,
    manager_id INTEGER  -- used for hierarchical / recursive example
);

INSERT INTO departments(dept_id, dept_name) VALUES
(1, 'HR'), (2, 'IT'), (3, 'Sales');

INSERT INTO employees(emp_id, name, salary, dept_id, manager_id) VALUES
(1, 'Amit', 40000, 1, NULL),
(2, 'Riya', 60000, 2, NULL),
(3, 'Ankit', 35000, 2, 2),
(4, 'Sneha', 55000, 3, NULL),
(5, 'Arjun', 45000, 3, 4),
(6, 'Nita', 30000, 1, 1);
