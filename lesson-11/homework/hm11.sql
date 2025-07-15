Here are my answers to the questions:

EASY LEVEL TASKS

1. Show all orders placed after 2022 with customer names
SELECT o.OrderID, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) > 2022;

2. Employees in Sales or Marketing departments
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');

3. Highest salary for each department
SELECT d.DepartmentName, MAX(e.Salary) AS MaxSalary
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY MaxSalary DESC;

4. USA customers who placed orders in 2023
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.OrderID, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND YEAR(o.OrderDate) = 2023;

5. Total orders per customer
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

6. Products from Gadget Supplies or Clothing Mart
SELECT p.ProductName, s.SupplierName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

7. Most recent order per customer (include customers with no orders)
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

MEDIUM LEVEL TASKS

8. Orders where total > 500
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.TotalAmount AS OrderTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount > 500;

9. Product sales in 2022 or SaleAmount > 400
SELECT p.ProductName, s.SaleDate, s.SaleAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = 2022 OR s.SaleAmount > 400;

10. Total sales per product
SELECT p.ProductName, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName;

11. Employees in HR with salary > 60000
SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Human Resources' AND e.Salary > 60000;

12. Products sold in 2023 and stock > 100
SELECT p.ProductName, s.SaleDate, p.StockQuantity
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = 2023 AND p.StockQuantity > 100;

13. Employees in Sales or hired after 2020
SELECT e.Name AS EmployeeName, d.DepartmentName, e.HireDate
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' OR YEAR(e.HireDate) > 2020;

HARD LEVEL TASKS

14. Orders by USA customers with address starting with 4 digits
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.OrderID, c.Address, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';

15. Product sales for Electronics or SaleAmount > 350
SELECT p.ProductName, c.CategoryName AS Category, s.SaleAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
JOIN Categories c ON p.Category = c.CategoryID
WHERE c.CategoryName = 'Electronics' OR s.SaleAmount > 350;

16. Product count per category
SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Products p
JOIN Categories c ON p.Category = c.CategoryID
GROUP BY c.CategoryName;

17. Orders by Los Angeles customers with amount > 300
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, c.City, o.OrderID, o.TotalAmount AS Amount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City = 'Los Angeles' AND o.TotalAmount > 300;

18. Employees in HR or Finance or names with 4+ vowels
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Human Resources', 'Finance')
   OR LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'a', ''))
       + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'e', ''))
       + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'i', ''))
       + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'o', ''))
       + LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'u', '')) >= 4;

19. Sales/Marketing employees with salary > 60000
SELECT e.Name AS EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing') AND e.Salary > 60000;
