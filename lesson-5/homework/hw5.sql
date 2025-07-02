Here are my answers to the questions:
Easy-Level Tasks
1. Rename ProductName column as Name in Products table:


SELECT ProductName AS Name
FROM Products;
2. Rename the Customers table as Client:


SELECT *
FROM Customers AS Client;
3. Combine ProductName from Products and Products_Discounted using UNION:


SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;
4. Find the intersection of Products and Products_Discounted using INTERSECT:


SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted;
5. Select distinct customer names and their country:


SELECT DISTINCT CustomerName, Country
FROM Customers;
6. Use CASE to show 'High' if Price > 1000, else 'Low':


SELECT ProductName, Price,
       CASE 
           WHEN Price > 1000 THEN 'High'
           ELSE 'Low'
       END AS PriceCategory
FROM Products;
7. Use IIF to show 'Yes' if Stock > 100, else 'No' (Products_Discounted):


SELECT ProductName, StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS StockStatus
FROM Products_Discounted;
Medium-Level Tasks
8. Same as #3 — combine ProductName from Products and Products_Discounted using UNION:


SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;
9. Return products from Products table that are not in Products_Discounted (EXCEPT):


SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM Products_Discounted;
10. Use IIF to label products as 'Expensive' if Price > 1000, else 'Affordable':


SELECT ProductName, Price,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceLabel
FROM Products;
11. Find employees with Age < 25 or Salary > 60000:


SELECT *
FROM Employees
WHERE Age < 25 OR Salary > 60000;
12. Update salary by 10% for employees in 'HR' department or EmployeeID = 5:


UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'HR' OR EmployeeID = 5;
Hard-Level Tasks
13. Categorize SaleAmount into 'Top Tier', 'Mid Tier', 'Low Tier' (Sales table):


SELECT SaleID, SaleAmount,
       CASE
           WHEN SaleAmount > 500 THEN 'Top Tier'
           WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
           ELSE 'Low Tier'
       END AS TierCategory
FROM Sales;
14. Customers who placed orders but have no record in Sales (use EXCEPT):


SELECT CustomerID FROM Orders
EXCEPT
SELECT CustomerID FROM Sales;
15. Use CASE to determine discount percentage based on Quantity (Orders table):


SELECT CustomerID, Quantity,
       CASE
           WHEN Quantity = 1 THEN '3%'
           WHEN Quantity BETWEEN 2 AND 3 THEN '5%'
           ELSE '7%'
       END AS DiscountPercentage
FROM Orders;
