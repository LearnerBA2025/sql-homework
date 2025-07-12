Here are my answers to the questions:

Easy-Level Tasks
1. Employees with salary > 50000 and their department names

SELECT 
    e.name AS EmployeeName,
    e.salary AS Salary,
    d.departmentname AS DepartmentName
FROM employees e
INNER JOIN departments d ON e.departmentid = d.departmentid
WHERE e.salary > 50000;

Returns only employees with a salary above 50000 and their department names. Uses INNER JOIN to ensure matching department.

2. Customer names and order dates for orders in 2023

SELECT 
    c.firstname AS FirstName,
    c.lastname AS LastName,
    o.orderdate AS OrderDate
FROM customers c
INNER JOIN orders o ON c.customerid = o.customerid
WHERE YEAR(o.orderdate) = 2023;

3. All employees and their department names (include those without department)

SELECT 
    e.name AS EmployeeName,
    d.departmentname AS DepartmentName
FROM employees e
LEFT JOIN departments d ON e.departmentid = d.departmentid;

4. All suppliers and the products they supply (include suppliers with no products)

SELECT 
    s.suppliername AS SupplierName,
    p.productname AS ProductName
FROM suppliers s
LEFT JOIN products p ON s.supplierid = p.supplierid;

5. All orders and corresponding payments (include unmatched on both sides)

SELECT 
    o.orderid AS OrderID,
    o.orderdate AS OrderDate,
    p.paymentdate AS PaymentDate,
    p.amount AS Amount
FROM orders o
FULL OUTER JOIN payments p ON o.orderid = p.orderid;

Uses FULL OUTER JOIN to include unmatched orders and unmatched payments.

6. Employees and the names of their managers

SELECT 
    e.name AS EmployeeName,
    m.name AS ManagerName
FROM employees e
LEFT JOIN employees m ON e.managerid = m.employeeid;

7. Students enrolled in 'Math 101'

SELECT 
    s.name AS StudentName,
    c.coursename AS CourseName
FROM students s
INNER JOIN enrollments e ON s.studentid = e.studentid
INNER JOIN courses c ON e.courseid = c.courseid
WHERE c.coursename = 'Math 101';

8. Customers who ordered more than 3 items

SELECT 
    c.firstname AS FirstName,
    c.lastname AS LastName,
    o.quantity AS Quantity
FROM customers c
INNER JOIN orders o ON c.customerid = o.customerid
WHERE o.quantity > 3;

9. Employees in 'Human Resources' department

SELECT 
    e.name AS EmployeeName,
    d.departmentname AS DepartmentName
FROM employees e
INNER JOIN departments d ON e.departmentid = d.departmentid
WHERE d.departmentname = 'Human Resources';

Medium-Level Tasks
10. Departments with more than 5 employees

SELECT 
    d.departmentname AS DepartmentName,
    COUNT(e.employeeid) AS EmployeeCount
FROM departments d
INNER JOIN employees e ON d.departmentid = e.departmentid
GROUP BY d.departmentname
HAVING COUNT(e.employeeid) > 5;

GROUP BY + HAVING counts employees per department and filters where count > 5.

11. Products that have never been sold

SELECT 
    p.productid AS ProductID,
    p.productname AS ProductName
FROM products p
LEFT JOIN sales s ON p.productid = s.productid
WHERE s.saleid IS NULL;

If saleid is NULL, that product was never involved in a sale.

12. Customers who have placed at least one order

SELECT 
    c.firstname AS FirstName,
    c.lastname AS LastName,
    COUNT(o.orderid) AS TotalOrders
FROM customers c
INNER JOIN orders o ON c.customerid = o.customerid
GROUP BY c.firstname, c.lastname;

Only customers with orders are included; each is grouped by name.

13. Show only records where both employee and department exist

SELECT 
    e.name AS EmployeeName,
    d.departmentname AS DepartmentName
FROM employees e
INNER JOIN departments d ON e.departmentid = d.departmentid;

INNER JOIN ensures neither EmployeeName nor DepartmentName is NULL.

14. Pairs of employees who report to the same manager

SELECT 
    e1.name AS Employee1,
    e2.name AS Employee2,
    e1.managerid AS ManagerID
FROM employees e1
INNER JOIN employees e2 
    ON e1.managerid = e2.managerid 
   AND e1.employeeid < e2.employeeid;

Self-join on managerid, employeeid < avoids duplicates like (A,B) and (B,A).

15. Orders from 2022 with customer names
SELECT 
    o.orderid AS OrderID,
    o.orderdate AS OrderDate,
    c.firstname AS FirstName,
    c.lastname AS LastName
FROM orders o
INNER JOIN customers c ON o.customerid = c.customerid
WHERE YEAR(o.orderdate) = 2022;

16. Employees in 'Sales' department with salary > 60000

SELECT 
    e.name AS EmployeeName,
    e.salary AS Salary,
    d.departmentname AS DepartmentName
FROM employees e
INNER JOIN departments d ON e.departmentid = d.departmentid
WHERE d.departmentname = 'Sales' AND e.salary > 60000;

17. Orders that have a corresponding payment

SELECT 
    o.orderid AS OrderID,
    o.orderdate AS OrderDate,
    p.paymentdate AS PaymentDate,
    p.amount AS Amount
FROM orders o
INNER JOIN payments p ON o.orderid = p.orderid;

INNER JOIN ensures only matched records (paid orders) are shown.

18. Products that were never ordered

SELECT 
    p.productid AS ProductID,
    p.productname AS ProductName
FROM products p
LEFT JOIN orders o ON p.productid = o.productid
WHERE o.orderid IS NULL;

If no orderid is matched, it means the product was never ordered.

Hard-Level Tasks

19. Employees whose salary is greater than the average salary in their department
  
select a.name as employeename, a.salary from employees a
inner join employees b on a.departmentid =b.departmentid 
group by a.name, a.salary
having a.salary > avg(b.salary)

20. Orders placed before 2020 that have no corresponding payment
SELECT 
    o.orderid AS OrderID,
    o.orderdate AS OrderDate
FROM orders o
LEFT JOIN payments p ON o.orderid = p.orderid
WHERE YEAR(o.orderdate) < 2020
  AND p.paymentid IS NULL;

LEFT JOIN ensures we keep all orders, even unpaid ones. We filter for unpaid + pre-2020.

21. Products that do not have a matching category

SELECT 
    p.productid AS ProductID,
    p.productname AS ProductName
FROM products p
LEFT JOIN categories c ON p.categoryid = c.categoryid
WHERE c.categoryid IS NULL;

Products with NULL in the categories join have no assigned category.

22. Employees who report to the same manager and earn more than 60000

SELECT 
    a.name AS Employee1,
    b.name AS Employee2,
    a.managerid AS ManagerID,
    b.salary AS Salary
FROM employees a
INNER JOIN employees b ON a.managerid = b.managerid AND a.employeeid < b.employeeid
WHERE a.salary > 60000 AND b.salary > 60000;

Self-join filters employee pairs with the same manager. We use < to avoid duplicate pairs and compare salaries.

23. Employees in departments starting with ‘M’
SELECT 
    e.name AS EmployeeName,
    d.departmentname AS DepartmentName
FROM employees e
INNER JOIN departments d ON e.departmentid = d.departmentid
WHERE d.departmentname LIKE 'M%';

LIKE 'M%' finds departments like "Marketing", "Management", etc.

24. Sales above 500, with product names
SELECT 
    s.saleid AS SaleID,
    p.productname AS ProductName,
    s.saleamount AS SaleAmount
FROM sales s
INNER JOIN products p ON s.productid = p.productid
WHERE s.saleamount > 500;

Joins sales with products, filters on saleamount > 500.

25. Students who have not enrolled in 'Math 101'

SELECT 
    s.studentid AS StudentID,
    s.name AS StudentName
FROM students s
WHERE s.studentid NOT IN (
    SELECT e.studentid
    FROM enrollments e
    INNER JOIN courses c ON e.courseid = c.courseid
    WHERE c.coursename = 'Math 101'
);

Subquery finds student IDs enrolled in 'Math 101'. NOT IN filters them out.

26. Orders missing payment details

SELECT 
    o.orderid AS OrderID,
    o.orderdate AS OrderDate,
    p.paymentid AS PaymentID
FROM orders o
LEFT JOIN payments p ON o.orderid = p.orderid
WHERE p.paymentid IS NULL;

Unpaid orders will have a NULL in p.paymentid.

27. Products in 'Electronics' or 'Furniture' categories

SELECT 
    p.productid AS ProductID,
    p.productname AS ProductName,
    c.categoryname AS CategoryName
FROM products p
INNER JOIN categories c ON p.categoryid = c.categoryid
WHERE c.categoryname IN ('Electronics', 'Furniture');

Filters for categories using IN ('Electronics', 'Furniture').
