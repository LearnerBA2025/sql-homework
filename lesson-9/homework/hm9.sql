Here are my answers to the questions. 

1. List all combinations of product names and supplier names
SELECT p.ProductName, s.SupplierName
FROM Products p
CROSS JOIN Suppliers s;

2. All combinations of departments and employees
SELECT d.DepartmentName, e.Name
FROM Departments d
CROSS JOIN Employees e;

3. Only combinations where supplier supplies product
SELECT s.SupplierName, p.ProductName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID;

4. Customer names and their order IDs
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, o.OrderID
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

5. All combinations of students and courses
SELECT s.Name, c.CourseName
FROM Students s
CROSS JOIN Courses c;

6. Product names and orders where product IDs match
SELECT p.ProductName, o.OrderID
FROM Products p
INNER JOIN Orders o ON p.ProductID = o.ProductID;

7. Employees whose DepartmentID matches the department
SELECT e.Name, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

8. Student names and their enrolled course IDs
SELECT s.Name, e.CourseID
FROM Enrollments e
INNER JOIN Students s ON s.StudentID = e.StudentID;

9. All orders with matching payments
SELECT o.OrderID, p.PaymentID, p.Amount
FROM Orders o
INNER JOIN Payments p ON o.OrderID = p.OrderID;

10. Show orders where product price is more than 100
SELECT o.OrderID, p.ProductName, p.Price
FROM Orders o
INNER JOIN Products p ON o.ProductID = p.ProductID
WHERE p.Price > 100;

MEDIUM LEVEL (10 TASKS)
11. Employee names and department names where IDs are NOT equal
SELECT e.Name, d.DepartmentName
FROM Employees e
CROSS JOIN Departments d
WHERE e.DepartmentID <> d.DepartmentID;

12. Orders where quantity > stock quantity
SELECT o.OrderID, p.ProductName, o.Quantity, p.StockQuantity
FROM Orders o
INNER JOIN Products p ON o.ProductID = p.ProductID
WHERE o.Quantity > p.StockQuantity;

13. Customers and product IDs where sale amount >= 500
SELECT c.FirstName + ' ' + c.LastName AS CustomerName, s.ProductID
FROM Sales s
INNER JOIN Customers c ON s.CustomerID = c.CustomerID
WHERE s.SaleAmount >= 500;

14. Student names and course names they are enrolled in
SELECT s.Name, c.CourseName
FROM Enrollments e
INNER JOIN Students s ON e.StudentID = s.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

15. Products and suppliers where supplier name contains 'Tech'
SELECT p.ProductName, s.SupplierName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName LIKE '%Tech%';

16. Orders where payment amount < total amount
SELECT o.OrderID, p.Amount, o.TotalAmount
FROM Orders o
INNER JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.Amount < o.TotalAmount;

17. Department name for each employee
SELECT e.Name, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

18. Products where category is 'Electronics' or 'Furniture'
SELECT p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.Category = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');

19. Sales from customers in 'USA'
SELECT s.*
FROM Sales s
INNER JOIN Customers c ON s.CustomerID = c.CustomerID
WHERE c.Country = 'USA';

20. Orders from Germany with total > 100
SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'Germany' AND o.TotalAmount > 100;

HARD LEVEL (5 TASKS)
21. All employee pairs from different departments
SELECT e1.Name AS Employee1, e2.Name AS Employee2
FROM Employees e1
CROSS JOIN Employees e2
WHERE e1.EmployeeID < e2.EmployeeID AND e1.DepartmentID <> e2.DepartmentID;

22. Payments where paid amount ≠ quantity × price
SELECT p.PaymentID, p.Amount, o.Quantity, pr.Price
FROM Payments p
INNER JOIN Orders o ON p.OrderID = o.OrderID
INNER JOIN Products pr ON o.ProductID = pr.ProductID
WHERE p.Amount <> o.Quantity * pr.Price;

23. Students not enrolled in any course
SELECT s.Name
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;

24. Managers whose salary is <= someone they manage
SELECT m.Name AS ManagerName, e.Name AS EmployeeName, m.Salary AS ManagerSalary, e.Salary AS EmployeeSalary
FROM Employees m
INNER JOIN Employees e ON m.EmployeeID = e.ManagerID
WHERE m.Salary <= e.Salary;

25. Customers who made orders but no payment recorded
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
LEFT JOIN Payments p ON p.OrderID = o.OrderID
WHERE p.OrderID IS NULL;
