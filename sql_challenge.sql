DROP TABLE IF EXISTS "employees" CASCADE;
CREATE TABLE "employees" (
    "emp_no" Int   NOT NULL,
    "emp_title_id" varchar(30)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(30)   NOT NULL,
    "last_name" varchar(30)   NOT NULL,
    "sex" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);
DROP TABLE IF EXISTS "dept_emps" CASCADE;
CREATE TABLE "dept_emps" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar(10)   NOT NULL
);
DROP TABLE IF EXISTS "dept_manager" CASCADE;
CREATE TABLE "dept_manager" (
    "dept_no" varchar(30)   NOT NULL,
    "emp_no" Int   NOT NULL
);
DROP TABLE IF EXISTS "salaries" CASCADE;
CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);
DROP TABLE IF EXISTS "titles" CASCADE;
CREATE TABLE "titles" (
    "title_id" varchar(10)   NOT NULL,
    "title" varchar(20)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);
DROP TABLE IF EXISTS "departments" CASCADE;
CREATE TABLE "departments" (
    "dept_no" varchar(10)   NOT NULL,
    "dept_name" varchar(20)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);
ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("employee_title_id")
REFERENCES "titles" ("title_id");
ALTER TABLE "dept_emps" ADD CONSTRAINT "fk_dept_emps_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
ALTER TABLE "dept_emps" ADD CONSTRAINT "fk_dept_emps_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");
ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");
ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


--Data Analysis
--List the following details of each employee: employee number, last name, first name, sex, and salary.

SELECT e.emp_no as "Employee Number"
	,e.first_name as "First Name"
	,e.sex as "Gender"
	,s.salary as "Salary"
from employees e
	INNER JOIN salaries s ON
		s.emp_no = e.emp_no;
		
--List first name, last name, and hire date for employees who were hired in 1986.

SELECT e.first_name as "First Name"
	,e.last_name as "Last Name"
	,e.hire_date as "Hire Date"
FROM employees e
WHERE 
	EXTRACT(YEAR FROM hire_date) = '1986';
	
	
--List the manager of each department with the following information: department number,
--department name, the manager's employee number, last name, first name.

SELECT dm.dept_no as "Department Number"
	,d.dept_name as "Department Name"
	,e.emp_no as "Manager's' Employee Number"
	,e.first_name as "Manager First Name"
	,e.last_name as "Manager Last Name"
FROM dept_manager dm
	INNER JOIN departments d ON
		d.dept_no = dm.dept_no
	INNER JOIN employees e ON
		e.emp_no = dm.emp_no;

--List the department of each employee with the following information: employee number,
--last name, first name, and department name.

SELECT e.emp_no as "Employee Number"
	,e.last_name as "Employee Last Name"
	,e.first_name as "Employee First Name"
	,d.dept_name as "Department Name"
FROM employees e
	INNER JOIN dept_emps de ON
		de.emp_no = e.emp_no
	INNER JOIN departments d ON
		d.dept_no = de.dept_no;
		

--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name as "Employee First Name"
	,last_name as "Employee Last Name"
	,sex as "Gender"
FROM employees
WHERE first_name = 'Hercules'
	AND UPPER(last_name) like 'B%';

--List all employees in the Sales department, including their employee
--number, last name, first name, and department name.
--dept_name = 'Sales'

SELECT e.emp_no as "Employee Number"
	,e.last_name as "Employee Last Name"
	,e.first_name as "Employee First Name"
	,d.dept_name as "Department Name"
FROM employees e
	INNER JOIN dept_emps de ON
	and d.dept_name = 'Sales';

--List all employees in the Sales and Development departments, including their
--employee number, last name, first name, and department name.

SELECT e.emp_no as "Eployee Number"
	,e.last_name as "Eployee Last Name"
	,e.first_name as "Employee First Name"
	,d.dept_name as "Department Name"
FROM employees e
	INNER JOIN dept_emps de ON
		de.emp_no = e.emp_no
	INNER JOIN departments d ON
		d.dept_no = de.dept_no
		AND d.dept_name IN ('Sales', 'Development');
		
--In descending order, list the frequency count of employee
--last names, i.e., how many employees share each last name.

SELECT last_name AS "Last Name"
	,COUNT(last_name) AS "Frequency COUNT"
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;
