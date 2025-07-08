Here are my anwers to the questions: 
Easy-Level Tasks
1. Using Products table, find the total number of products available in each category.

SELECT Category, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Category;
2. Using Products table, get the average price of products in the 'Electronics' category.

SELECT AVG(Price) AS AvgElectronicsPrice
FROM Products
WHERE Category = 'Electronics';
3. Using Customers table, list all customers from cities that start with 'L'.

SELECT *
FROM Customers
WHERE City LIKE 'L%';
4. Using Products table, get all product names that end with 'er'.

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er';
5. Using Customers table, list all customers from countries ending in 'A'.

SELECT *
FROM Customers
WHERE Country LIKE '%A';
6. Using Products table, show the highest price among all products.

SELECT MAX(Price) AS HighestPrice
FROM Products;
7. Using Products table, label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.

SELECT ProductName, StockQuantity,
       CASE 
           WHEN StockQuantity < 30 THEN 'Low Stock'
           ELSE 'Sufficient'
       END AS StockStatus
FROM Products;
8. Using Customers table, find the total number of customers in each country.

SELECT Country, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY Country;
9. Using Orders table, find the minimum and maximum quantity ordered.

SELECT MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM Orders;

Medium-Level Tasks
10. Using Orders and Invoices tables, list customer IDs who placed orders in 2023 January but did not have invoices.

SELECT DISTINCT o.CustomerID
FROM Orders o
LEFT JOIN Invoices i 
    ON o.CustomerID = i.CustomerID 
       AND i.InvoiceDate >= '2023-01-01' AND i.InvoiceDate < '2023-02-01'
WHERE 
    o.OrderDate >= '2023-01-01' AND o.OrderDate < '2023-02-01'
    AND i.InvoiceID IS NULL;

11. Using Products and Products_Discounted table, combine all product names including duplicates.

SELECT ProductName FROM Products
UNION ALL
SELECT ProductName FROM Products_Discounted;

UNION ALL includes duplicates — shows all names from both tables, even if they repeat.

12. Using Products and Products_Discounted table, combine all product names without duplicates.

SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

Simple UNION removes duplicates automatically.

13. Using Orders table, find the average order amount by year.

SELECT YEAR(OrderDate) AS OrderYear, AVG(TotalAmount) AS AvgOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;



14. Using Products table, group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return product name and price group.

SELECT ProductName,
       CASE
           WHEN Price < 100 THEN 'Low'
           WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
           ELSE 'High'
       END AS PriceGroup
FROM Products;

Each product is grouped into price ranges.

15. Using City_Population table, use Pivot to show values of Year column in separate columns ([2012], [2013]) and copy results to a new Population_Each_Year table.

SELECT district_id, district_name, [2012], [2013]
INTO Population_Each_Year
FROM (
    SELECT district_id, district_name, population, year
    FROM city_population
) AS src
PIVOT (
    SUM(population)
    FOR year IN ([2012], [2013])
) AS pvt;



16. Using Sales table, find total sales per ProductID.

SELECT ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

Grouped by product, we get total money made per product.

17. Using Products table, use wildcard to find products that contain 'oo' in the name. Return product name.

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%';
%oo% means it has “oo” anywhere in the name.

18. Using City_Population table, use Pivot to show values of City column in separate columns (Bektemir, Chilonzor, Yakkasaroy) and copy results to a new Population_Each_City table.

SELECT year, [Bektemir], [Chilonzor], [Yakkasaroy]
INTO Population_Each_City
FROM (
    SELECT year, district_name, population
    FROM city_population
    WHERE district_name IN ('Bektemir', 'Chilonzor', 'Yakkasaroy')
) AS src
PIVOT (
    SUM(population)
    FOR district_name IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS pvt;



Hard-Level Tasks

SELECT TOP 3 CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;



20. Transform Population_Each_Year table back to original format (City_Population).
SELECT 
    District_ID,
    District_Name,
    Year,
    Population
FROM Population_Each_Year
UNPIVOT (
    Population FOR Year IN ([2012], [2013])
) AS UnpivotedYear;



21. Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)

SELECT p.ProductName, COUNT(s.SaleID) AS TimesSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName
ORDER BY TimesSold DESC;

This shows how often each product appears in the Sales table (how many times it was sold).

22. Transform Population_Each_City table back to original format (City_Population).
SELECT 
    District_Name = City,
    Year,
    Population
FROM Population_Each_City
UNPIVOT (
    Population FOR City IN ([Chilonzor], [Yakkasaroy], [Bektemir])
) AS UnpivotedCity;

