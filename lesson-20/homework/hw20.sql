Here are my answers to the questions:

1) Find customers who purchased at least one item in March 2024 using EXISTS

SELECT DISTINCT s.CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s.CustomerName
      AND YEAR(s2.SaleDate) = 2024
      AND MONTH(s2.SaleDate) = 3
);

2) Product with the highest total sales revenue (use a subquery)

SELECT Product, TotalRevenue
FROM (
    SELECT Product, SUM(Quantity * Price) AS TotalRevenue
    FROM #Sales
    GROUP BY Product
) t
WHERE TotalRevenue = (
    SELECT MAX(ProductTotal)
    FROM (
        SELECT SUM(Quantity * Price) AS ProductTotal
        FROM #Sales
        GROUP BY Product
    ) x
);


3) Find the second highest sale amount (using a subquery)
Interpretation: sale amount = Quantity * Price per sale row. Return the second-highest distinct sale amount.


SELECT TOP (1) SaleAmount
FROM (
    SELECT DISTINCT (Quantity * Price) AS SaleAmount
    FROM #Sales
) t
WHERE SaleAmount < (SELECT MAX(Quantity * Price) FROM #Sales)
ORDER BY SaleAmount DESC;


4) Total quantity of products sold per month (using a subquery / correlated)

SELECT DISTINCT
    YEAR(s.SaleDate) AS SaleYear,
    MONTH(s.SaleDate) AS SaleMonth,
    (
      SELECT SUM(s2.Quantity)
      FROM #Sales s2
      WHERE YEAR(s2.SaleDate) = YEAR(s.SaleDate)
        AND MONTH(s2.SaleDate) = MONTH(s.SaleDate)
    ) AS TotalQuantity
FROM #Sales s
ORDER BY SaleYear, SaleMonth;


5) Find customers who bought the same product as another customer (use EXISTS)

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.Product = s1.Product
      AND s2.CustomerName <> s1.CustomerName
);


6) Return how many fruits each person has at individual fruit level (pivot-style)

SELECT
    Name,
    SUM(CASE WHEN Fruit = 'Apple'  THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name
ORDER BY Name;
Explanation: conditional aggregation counts each fruit per person. This returns the exact expected output (Apple / Orange / Banana counts).
Expected (as in your example):

Francesko | 3 | 2 | 1

Li | 2 | 1 | 1

Mario | 3 | 1 | 2

7) Return older people in the family with younger ones (transitive ancestor → descendant pairs)
You want all ancestor→descendant pairs (transitive closure). Use a recursive CTE:


WITH Ancestors AS (
    -- base parent-child pairs
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family
    UNION ALL
    -- climb down one generation: combine existing ancestor with next child
    SELECT a.PID, f.ChildID
    FROM Ancestors a
    JOIN Family f ON a.CHID = f.ParentId
)
SELECT DISTINCT PID, CHID
FROM Ancestors
ORDER BY PID, CHID;
Explanation: recursion expands direct parent-child to grandparent, great-grandparent, etc. Output matches your expected six pairs.

8) For every customer that had a delivery to California, return that customer’s orders to Texas

SELECT o.CustomerID, o.OrderID, o.DeliveryState, o.Amount
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
    SELECT 1
    FROM #Orders o2
    WHERE o2.CustomerID = o.CustomerID
      AND o2.DeliveryState = 'CA'
);


9) Insert / populate resident names when missing (two safe steps)
A. If fullname is missing but the address string contains name=..., extract and set fullname.
B. If address doesn't contain name=..., append name=<fullname> so the address contains the name.


-- A) Extract name=... from address into fullname when fullname is NULL/empty
;WITH cte AS (
    SELECT resid, fullname, address,
        CASE
            WHEN CHARINDEX('name=', address) > 0
            THEN LTRIM(RTRIM(
                 SUBSTRING(
                    address,
                    CHARINDEX('name=', address) + LEN('name='),
                    CHARINDEX(' ', address + ' ', CHARINDEX('name=', address) + LEN('name=')) 
                      - (CHARINDEX('name=', address) + LEN('name='))
                 )
            ))
            ELSE NULL
        END AS extracted_name
    FROM #residents
)
UPDATE c
SET fullname = extracted_name
FROM cte c
WHERE (c.fullname IS NULL OR LTRIM(RTRIM(c.fullname)) = '')
  AND c.extracted_name IS NOT NULL;

-- B) If address lacks 'name=' token, append it using the fullname value
UPDATE #residents
SET address = RTRIM(address) + ' name=' + fullname
WHERE CHARINDEX('name=', address) = 0
  AND fullname IS NOT NULL
  AND LTRIM(RTRIM(fullname)) <> '';

10) Route(s) from Tashkent to Khorezm: show full path and total cost (cheapest → most expensive)
We need to enumerate paths in the directed graph and sum cost; use a recursive CTE that builds path strings and accumulates cost:


;WITH Paths AS (
    -- starting edges from Tashkent
    SELECT 
      CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
      DepartureCity, ArrivalCity,
      Cost AS TotalCost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    -- extend paths
    SELECT 
      p.Route + ' - ' + r.ArrivalCity AS Route,
      p.DepartureCity,
      r.ArrivalCity,
      p.TotalCost + r.Cost AS TotalCost
    FROM Paths p
    JOIN #Routes r
      ON p.ArrivalCity = r.DepartureCity
    -- avoid cycles by ensuring the new city isn't already in the route string
    WHERE CHARINDEX(r.ArrivalCity, p.Route) = 0
)
SELECT Route, TotalCost AS Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm'
ORDER BY TotalCost;
Explanation: recursive CTE builds all simple paths from Tashkent to Khorezm and sums cost; ordering returns cheapest first. Expected two routes from your sample:

Tashkent - Samarkand - Khorezm | Cost = 500

Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm | Cost = 650

11) Rank products based on their order of insertion (assign a running group/rank when Vals = 'Product')
You likely want to assign the product group number that increases each time a row with Vals = 'Product' appears. Use a cumulative SUM window:


SELECT
    ID,
    Vals,
    SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END)
        OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS ProductRank
FROM #RankingPuzzle
ORDER BY ID;
Explanation: ProductRank increases each time a Product row appears; rows after that Product belong to the same product rank. If you only want the product rows (the product headers) in insertion order:


SELECT DISTINCT
    SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END)
        OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS ProductRank,
    ID
FROM #RankingPuzzle
WHERE Vals = 'Product'
ORDER BY ProductRank;
12) Find employees whose sales were higher than the average in their department

SELECT EmployeeID, EmployeeName, Department, SalesAmount
FROM #EmployeeSales es
WHERE SalesAmount > (
    SELECT AVG(es2.SalesAmount)
    FROM #EmployeeSales es2
    WHERE es2.Department = es.Department
)
ORDER BY Department, SalesAmount DESC;
Explanation: compare each employee to the departmental average.
From your data this returns (examples): Frank, Isaac (Electronics), David, Jack (Furniture), Hannah, Nathan (Clothing).

13) Find employees who had the highest sales in any given month using EXISTS
(Include ties.)


SELECT es.EmployeeID, es.EmployeeName, es.SalesMonth, es.SalesYear, es.SalesAmount
FROM #EmployeeSales es
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales es2
    WHERE es2.SalesMonth = es.SalesMonth
      AND es2.SalesYear  = es.SalesYear
      AND es2.SalesAmount > es.SalesAmount
)
ORDER BY es.SalesYear, es.SalesMonth;
Explanation: for each employee row, we ensure there is no other employee in the same month/year with a strictly higher sale (so rows that equal the max remain). Result: Bob (month1), Frank (month2), Isaac (month3), Nathan (month4).

14) Find employees who made sales in every month (use NOT EXISTS)
We interpret “every month” as every distinct month/year combination present in #EmployeeSales. Use the double NOT EXISTS pattern:


SELECT e.EmployeeID, e.EmployeeName
FROM #EmployeeSales e
GROUP BY e.EmployeeID, e.EmployeeName
HAVING NOT EXISTS (
    SELECT 1
    FROM (
       SELECT DISTINCT SalesMonth, SalesYear FROM #EmployeeSales
    ) m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales es2
        WHERE es2.EmployeeID = e.EmployeeID
          AND es2.SalesMonth = m.SalesMonth
          AND es2.SalesYear  = m.SalesYear
    )
);
Explanation: For each employee we check that there is no month (from the set of months in the table) in which that employee did not have any sale. With your sample data there is no employee that appears in all months (months present: Jan, Feb, Mar, Apr) — so result set will be empty.

15) Products with price more expensive than the average price of all products

SELECT Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

16) Products that have stock count lower than the highest stock count

SELECT Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

17) Names of products that belong to the same category as 'Laptop'

SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop')
  AND Name <> 'Laptop';
Explanation: the subquery returns the category of Laptop, then we list other products in that category.

18) Products whose price is greater than the lowest price in the Electronics category

SELECT Name, Price, Category
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category = 'Electronics');

19) Products that have a higher price than the average price of their category

SELECT p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);
20) Products that have been ordered at least once

SELECT DISTINCT p.ProductID, p.Name
FROM Products p
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID
);
21) Names of products that have been ordered more than the average quantity ordered
Interpretation: compute total ordered quantity per product, then compare to the average of those totals.


WITH ProductTotals AS (
    SELECT ProductID, SUM(Quantity) AS TotalQty
    FROM Orders
    GROUP BY ProductID
)
SELECT p.Name, pt.TotalQty
FROM ProductTotals pt
JOIN Products p ON p.ProductID = pt.ProductID
WHERE pt.TotalQty > (
    SELECT AVG(TotalQty) FROM ProductTotals
);
Explanation: ProductTotals sums quantities per product; we then select those totals larger than the average of all product totals.

22) Products that have never been ordered

SELECT Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID
);
Explanation: if every product appears at least once in your Orders sample, this returns an empty set. (Based on your sample, all ProductID 1..15 appear, so probably none.)

23) Retrieve the product with the highest total quantity ordered
(Handle ties safely.)


WITH Totals AS (
    SELECT p.ProductID, p.Name, SUM(o.Quantity) AS TotalQty
    FROM Orders o
    JOIN Products p ON p.ProductID = o.ProductID
    GROUP BY p.ProductID, p.Name
)
SELECT Name, TotalQty
FROM Totals
WHERE TotalQty = (SELECT MAX(TotalQty) FROM Totals);
