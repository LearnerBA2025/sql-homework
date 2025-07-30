Here are my answers to the questions: 

Level 1: Basic Subqueries

1. Find Employees with Minimum Salary
SELECT *
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);
This finds the lowest salary in the company and matches it against the salary column to return all employees who earn it (there could be more than one).

2. Find Products Above Average Price

SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);
We're calculating the average price once and filtering the products that are priced above that average.

Level 2: Nested Subqueries with Conditions

3. Find Employees in Sales Department

SELECT *
FROM employees
WHERE department_id = (
    SELECT id
    FROM departments
    WHERE department_name = 'Sales'
);
We're using a subquery to get the ID of the "Sales" department and then using it to filter employees.

4. Find Customers with No Orders

SELECT *
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);
We're selecting customers whose IDs are not found in the orders table — i.e., they never ordered.

Level 3: Aggregation and Grouping in Subqueries

5. Find Products with Max Price in Each Category

SELECT *
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
);
This is a correlated subquery: for each product, it compares against the maximum price in that product's category.

6. Find Employees in Department with Highest Average Salary
SELECT *
FROM employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);
We first find the department with the highest average salary, then filter employees from that department.

Level 4: Correlated Subqueries

7. Find Employees Earning Above Department Average
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);
For each employee, we compute the average salary of their department and return those who earn more than that.

8. Find Students with Highest Grade per Course

SELECT *
FROM grades g
WHERE grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);
This gives all top scorers for each course — including ties if multiple students got the top grade.

To include student names:

SELECT s.name, g.course_id, g.grade
FROM grades g
JOIN students s ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);

Level 5: Ranking and Complex Subqueries

9. Find Third-Highest Price per Category

SELECT *
FROM products p
WHERE 2 = (
    SELECT COUNT(DISTINCT price)
    FROM products
    WHERE category_id = p.category_id AND price > p.price
);
We count how many unique prices are greater than each product's price within its category. If exactly two are higher, then it's the 3rd highest.

10. Find Employees whose Salary is Between Company Average and Department Max
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
AND salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);
Here, we compare each employee’s salary with two benchmarks: overall company average and the max salary in their department.
