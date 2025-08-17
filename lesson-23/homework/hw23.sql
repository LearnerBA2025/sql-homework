Here are my answers to the questions: 

Puzzle 1 — Month with leading zero
Month padded to two digits (e.g., 01..12)
SELECT
    Id,
    Dt,
    RIGHT('0' + CONVERT(varchar(2), MONTH(Dt)), 2) AS MonthPrefixedWithZero
FROM dbo.Dates
ORDER BY Id;

Why: MONTH() extracts 1–12; RIGHT('0' + <month>, 2) forces 01..09.


Puzzle 2 — Distinct Ids and SUM of Max(Vals) per (Id, rID)
First get the max Vals for each (Id, rID), then aggregate
WITH Maxes AS (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM dbo.MyTabel
    GROUP BY Id, rID
)
SELECT
    COUNT(DISTINCT Id)        AS Distinct_Ids,
    rID,
    SUM(MaxVals)              AS TotalOfMaxVals
FROM Maxes
GROUP BY rID;


Matches expected: Distinct_Ids = 3, rID = 9, TotalOfMaxVals = 32.

Puzzle 3 — Keep rows where length is between 6 and 10
SELECT Id, Vals
FROM dbo.TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10
ORDER BY Id, Vals;


Notes: LEN(NULL) returns NULL (filtered out) and LEN('') = 0. This keeps lengths 6–10 inclusive.

Puzzle 4 — For each ID, return the Item at the maximum Vals
One row per ID (ties broken arbitrarily); use WITH TIES if you want all tied max rows
WITH Ranked AS (
    SELECT
        ID, Item, Vals,
        ROW_NUMBER() OVER (PARTITION BY ID ORDER BY Vals DESC, Item) AS rn
    FROM dbo.TestMaximum
)
SELECT ID, Item, Vals
FROM Ranked
WHERE rn = 1
ORDER BY ID;


If you want all items tied at the maximum per ID, replace ROW_NUMBER() with RANK() and filter rank = 1.

Puzzle 5 — Sum of maxima per (Id, DetailedNumber), then roll up by Id
WITH MaxPerDetail AS (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVals
    FROM dbo.SumOfMax
    GROUP BY Id, DetailedNumber
)
SELECT
    Id,
    SUM(MaxVals) AS SumOfMax
FROM MaxPerDetail
GROUP BY Id
ORDER BY Id;


Matches expected: (101 → 11), (102 → 6).

Puzzle 6 — a − b, but show blank when the difference is zero
SELECT
    Id, a, b,
    CASE
        WHEN a - b = 0 THEN ''      -- blank when zero
        ELSE CONVERT(varchar(20), a - b)
    END AS OUTPUT
FROM dbo.TheZeroPuzzle
ORDER BY Id;


Notes: Output is textual by design so “blank” is possible.

Sales dataset (20 rows)

Puzzle 7
  Total revenue (Σ QuantitySold × UnitPrice)
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM dbo.Sales;


Expected with your sample data: 69160.00

Puzzle 8 Average unit price (across all sales rows)
SELECT AVG(UnitPrice) AS AvgUnitPrice
FROM dbo.Sales;


Expected: 551.00

Puzzle 9

Number of sales transactions (row count)
SELECT COUNT(*) AS Transactions
FROM dbo.Sales;


Expected: 20

Puzzle 10
  
Highest number of units in a single transaction
SELECT MAX(QuantitySold) AS MaxUnitsInOneSale
FROM dbo.Sales;


Expected: 30

Puzzle 11
  
How many products were sold in each category (sum of quantities)
SELECT
    Category,
    SUM(QuantitySold) AS TotalUnits
FROM dbo.Sales
GROUP BY Category
ORDER BY Category;


Expected:

Appliances → 57

Electronics → 155

Puzzle 12
  
Total revenue per region
SELECT
    Region,
    SUM(QuantitySold * UnitPrice) AS Revenue
FROM dbo.Sales
GROUP BY Region
ORDER BY Region;


Expected:

East → 8510.00

North → 31350.00

South → 14400.00

West → 14900.00

Puzzle 13
  
  Product with the highest total revenue
SELECT TOP (1) WITH TIES
    Product,
    SUM(QuantitySold * UnitPrice) AS Revenue
FROM dbo.Sales
GROUP BY Product
ORDER BY Revenue DESC;


Expected top: Laptop → 8000.00
(next: Smartphone 7500, Camera 6300, TV 6000, …)

Puzzle 14
  
  Running total of revenue by SaleDate
SELECT
    SaleID,
    SaleDate,
    Product,
    QuantitySold * UnitPrice AS Revenue,
    SUM(QuantitySold * UnitPrice)
        OVER (ORDER BY SaleDate, SaleID
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningRevenue
FROM dbo.Sales
ORDER BY SaleDate, SaleID;


Tip: SaleID breaks same-day ties deterministically.

Puzzle 15
  
  Category contribution to total revenue (amount + %)
WITH Cat AS (
    SELECT Category, SUM(QuantitySold * UnitPrice) AS Revenue
    FROM dbo.Sales
    GROUP BY Category
)
SELECT
    Category,
    Revenue,
    CAST(Revenue * 100.0 / SUM(Revenue) OVER () AS decimal(6,2)) AS PctOfTotal
FROM Cat
ORDER BY Revenue DESC;


Expected:

Electronics → 45700.00 (~66.08%)

Appliances → 23460.00 (~33.92%)

Customers × Sales

Puzzle 16
  
  Show all sales with customer names
SELECT
    s.SaleID, s.SaleDate, s.Product, s.Category, s.Region,
    s.QuantitySold, s.UnitPrice,
    s.QuantitySold * s.UnitPrice AS Revenue,
    c.CustomerID, c.CustomerName
FROM dbo.Sales AS s
JOIN dbo.Customers AS c
  ON c.CustomerID = s.CustomerID
ORDER BY s.SaleDate, s.SaleID;

Puzzle 17 
  
Customers who have not made any purchases
SELECT c.CustomerID, c.CustomerName, c.Region, c.JoinDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Sales AS s
  ON s.CustomerID = c.CustomerID
WHERE s.CustomerID IS NULL
ORDER BY c.CustomerID;


With your sample data: returns no rows (all 10 customers have at least one sale).

Puzzle 18
  
  Total revenue generated from each customer
SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS Revenue
FROM dbo.Customers AS c
JOIN dbo.Sales     AS s
  ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Revenue DESC;


Top expected: Jane Smith (ID 2) → 11550.00
  
 Puzzle 19

  Customer contributing the most revenue
SELECT TOP (1) WITH TIES
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS Revenue
FROM dbo.Customers AS c
JOIN dbo.Sales     AS s
  ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Revenue DESC;


Expected: Jane Smith (ID 2)

Puzzle 20
  
“Total sales per customer” (comprehensive summary)
SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(*)                           AS Transactions,
    SUM(s.QuantitySold)                AS TotalUnits,
    SUM(s.QuantitySold * s.UnitPrice)  AS Revenue
FROM dbo.Customers AS c
JOIN dbo.Sales     AS s
  ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Revenue DESC, c.CustomerID;

Products

Puzzle 21  
  
Products that have been sold at least once

Your Sales table stores the product name, not ProductID, so we join by ProductName.

SELECT DISTINCT p.ProductID, p.ProductName, p.Category, p.SellingPrice
FROM dbo.Products AS p
JOIN dbo.Sales    AS s
  ON s.Product = p.ProductName
ORDER BY p.ProductID;

Puzzle 22
  
Most expensive product (by SellingPrice)
SELECT TOP (1) WITH TIES
    ProductID, ProductName, Category, SellingPrice
FROM dbo.Products
ORDER BY SellingPrice DESC;


Expected: Refrigerator (1500.00) or Air Conditioner isn’t in Products table; among given 10, Refrigerator is highest.

Puzzle 23
  
Products priced above their category average (SellingPrice)
WITH AvgByCat AS (
    SELECT
        Category,
        AVG(SellingPrice) AS CatAvgPrice
    FROM dbo.Products
    GROUP BY Category
)
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    p.SellingPrice,
    a.CatAvgPrice
FROM dbo.Products AS p
JOIN AvgByCat     AS a
  ON a.Category = p.Category
WHERE p.SellingPrice > a.CatAvgPrice
ORDER BY p.Category, p.SellingPrice DESC;


Variant without CTE (pure window function):

SELECT
    ProductID, ProductName, Category, SellingPrice,
    AVG(SellingPrice) OVER (PARTITION BY Category) AS CatAvgPrice
FROM dbo.Products
WHERE SellingPrice >
      AVG(SellingPrice) OVER (PARTITION BY Category)
ORDER BY Category, SellingPrice DESC;
