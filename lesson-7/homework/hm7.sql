Here are my answers to the question: 
Easy-Level Tasks (1–10)
1. Minimum product price:
SELECT MIN(Price) AS MinPrice FROM Products;
2. Maximum salary:
SELECT MAX(Salary) AS MaxSalary FROM Employees;
3. Count rows in Customers table:
SELECT COUNT(*) AS TotalCustomers FROM Customers;
4. Count unique product categories:
SELECT COUNT(DISTINCT Category) AS UniqueCategories FROM Products;
5. Total sales amount for product ID 7:
SELECT SUM(SaleAmount) AS TotalSalesForProduct7
FROM Sales
WHERE ProductID = 7;
6. Average employee age:
SELECT AVG(Age) AS AverageAge FROM Employees;
7. Count employees in each department:
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;
8. Min & Max product price by category:
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;
9. Total sales per customer:
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;
10. Departments with more than 5 employees:
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName
HAVING COUNT(*) > 5;
Medium-Level Tasks (11–19)
11. Total & average sales by product category:
SELECT P.Category, SUM(S.SaleAmount) AS TotalSales, AVG(S.SaleAmount) AS AvgSales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category;
12. Count employees in HR:
SELECT COUNT(*) AS HREmployeeCount
FROM Employees
WHERE DepartmentName = 'HR';
13. Highest & lowest salary by department:
SELECT DepartmentName, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY DepartmentName;
14. Average salary per department:
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName;
15. AVG salary and COUNT per department:
SELECT DepartmentName, AVG(Salary) AS AvgSalary, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;
16. Categories with AVG price > 400:
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;
17. Total sales by year:
SELECT YEAR(SaleDate) AS SaleYear, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);
18. Customers with at least 3 orders:
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 3;
19. Filter departments with avg salary > 60000:
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000;
Hard-Level Tasks (20–25)
20. Categories with AVG price > 150:
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150;
21. Customers with total sales > 1500:
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;
22. Departments with AVG salary > 65000 + total:
SELECT DepartmentName, AVG(Salary) AS AvgSalary, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;
23. Orders with Freight > $50 per customer + least:
Assuming Freight column is in TSQL2012.Sales.Orders, use:

SELECT CustomerID,
       SUM(CASE WHEN Freight > 50 THEN TotalDue ELSE 0 END) AS TotalFreightOver50,
       MIN(TotalDue) AS LeastPurchase
FROM TSQL2012.Sales.Orders
GROUP BY CustomerID;
24. Total sales & unique products sold per month (min 2):
SELECT
    YEAR(OrderDate) AS SaleYear,
    MONTH(OrderDate) AS SaleMonth,
    SUM(TotalAmount) AS MonthlySales,
    COUNT(DISTINCT ProductID) AS UniqueProductsSold
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING COUNT(DISTINCT ProductID) >= 2;
25. Min & Max quantity per year:
SELECT
    YEAR(OrderDate) AS OrderYear,
    MIN(Quantity) AS MinQuantity,
    MAX(Quantity) AS MaxQuantity
FROM Orders
GROUP BY YEAR(OrderDate);
