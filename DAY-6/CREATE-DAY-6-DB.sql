-- Drop if exists (safe re-run)
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS projects;

-- Departments table
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT
);

-- Employees table (self-referencing manager_id)
CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY,
    name TEXT,
    dept_id INTEGER,
    manager_id INTEGER,
    salary INTEGER
);

-- Projects table
CREATE TABLE projects (
    project_id INTEGER PRIMARY KEY,
    project_name TEXT,
    dept_id INTEGER
);

-- Insert data
INSERT INTO departments VALUES
(1,'HR'), (2,'IT'), (3,'Sales');

INSERT INTO employees VALUES
(1,'Amit',1,NULL,50000),
(2,'Riya',2,1,60000),
(3,'Ankit',2,2,40000),
(4,'Sneha',3,1,55000),
(5,'Arjun',3,4,45000);

INSERT INTO projects VALUES
(101,'Recruitment App',1),
(102,'E-Commerce',2),
(103,'CRM System',3),
(104,'Internal Tool',2);
