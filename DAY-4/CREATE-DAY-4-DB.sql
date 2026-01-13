CREATE TABLE departments (
  dept_id INTEGER PRIMARY KEY,
  dept_name TEXT
);

CREATE TABLE employees (
  emp_id INTEGER PRIMARY KEY,
  name TEXT,
  dept_id INTEGER,
  salary INTEGER,
  hire_date DATE
);

INSERT INTO departments (dept_id, dept_name) VALUES
(1,'HR'), (2,'IT'), (3,'Sales');

INSERT INTO employees (emp_id, name, dept_id, salary, hire_date) VALUES
(1,'Amit',1,40000,'2024-01-05'),
(2,'Riya',2,60000,'2023-08-12'),
(3,'Ankit',2,35000,'2024-03-20'),
(4,'Sneha',3,55000,'2022-11-01'),
(5,'Arjun',3,45000,'2023-05-15'),
(6,'Nita',1,30000,'2024-02-10'),
(7,'Aakash',2,60000,'2021-07-07'),
(8,'Pooja',3,45000,'2024-04-01');
