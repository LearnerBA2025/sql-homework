Here are my answers to the questions: 

EASY TASKS

1. Create a numbers table using a recursive query from 1 to 1000
WITH NumbersCTE AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM NumbersCTE
    WHERE Number < 1000
)
SELECT * FROM NumbersCTE
OPTION (MAXRECURSION 1000);

2. Total sales per employee using a derived table
SELECT e.EmployeeID, e.FirstName, e.LastName, s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) s ON e.EmployeeID = s.EmployeeID;

3. CTE to find the average salary of employees
WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary FROM Employees
)
SELECT * FROM AvgSalaryCTE;

4. Derived table to find the highest sales for each product
SELECT p.ProductID, p.ProductName, s.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) s ON p.ProductID = s.ProductID;

5. Double each number starting from 1, max < 1000000
WITH DoubleCTE AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num * 2
    FROM DoubleCTE
    WHERE Num * 2 < 1000000
)
SELECT * FROM DoubleCTE;

6. Employees with more than 5 sales
WITH SalesCountCTE AS (
    SELECT EmployeeID, COUNT(*) AS SaleCount
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
JOIN SalesCountCTE s ON e.EmployeeID = s.EmployeeID;

7. Products with sales greater than $500
WITH SalesOver500 AS (
    SELECT ProductID
    FROM Sales
    GROUP BY ProductID
    HAVING SUM(SalesAmount) > 500
)
SELECT p.ProductID, p.ProductName
FROM Products p
JOIN SalesOver500 s ON p.ProductID = s.ProductID;

8. Employees with salaries above average
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary
FROM Employees e
CROSS JOIN AvgSalary
WHERE e.Salary > AvgSalary.AvgSal;

MEDIUM TASKS

1. Top 5 employees by number of orders
SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, x.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) x ON e.EmployeeID = x.EmployeeID
ORDER BY x.OrderCount DESC;

2. Sales per product category
SELECT p.CategoryID, SUM(s.SalesAmount) AS TotalSales
FROM (
    SELECT ProductID, SalesAmount FROM Sales
) s
JOIN Products p ON p.ProductID = s.ProductID
GROUP BY p.CategoryID;

3. Factorial of each value
WITH FactorialCTE AS (
    SELECT Number, CAST(1 AS BIGINT) AS Fact, Number AS Original
    FROM Numbers1
    UNION ALL
    SELECT Number - 1, Fact * Number, Original
    FROM FactorialCTE
    WHERE Number > 1
)
SELECT Original, MAX(Fact) AS Factorial
FROM FactorialCTE
GROUP BY Original
ORDER BY Original;

4. Recursively split string into characters
WITH CharCTE AS (
    SELECT Id, 1 AS Position, SUBSTRING(String, 1, 1) AS Character, String
    FROM Example
    WHERE LEN(String) > 0
    UNION ALL
    SELECT Id, Position + 1, SUBSTRING(String, Position + 1, 1), String
    FROM CharCTE
    WHERE Position < LEN(String)
)
SELECT Id, Position, Character FROM CharCTE;

5. Monthly sales difference using CTE
WITH SalesPerMonth AS (
    SELECT FORMAT(SaleDate, 'yyyy-MM') AS MonthKey, SUM(SalesAmount) AS MonthlySales
    FROM Sales
    GROUP BY FORMAT(SaleDate, 'yyyy-MM')
),
RankedMonths AS (
    SELECT MonthKey, MonthlySales,
           LAG(MonthlySales) OVER (ORDER BY MonthKey) AS PrevMonthSales
    FROM SalesPerMonth
)
SELECT MonthKey, MonthlySales, ISNULL(MonthlySales - PrevMonthSales, 0) AS Difference
FROM RankedMonths;

6. Employees with sales > $45000 per quarter
SELECT e.EmployeeID, e.FirstName, e.LastName, x.Quarter, x.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, DATEPART(QUARTER, SaleDate) AS Quarter, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) x ON e.EmployeeID = x.EmployeeID;

DIFFICULT TASKS

1. Recursive Fibonacci
WITH Fibonacci AS (
    SELECT 1 AS N, 0 AS Fib
    UNION ALL
    SELECT 2, 1
    UNION ALL
    SELECT N + 1, 
           (SELECT f1.Fib + f2.Fib FROM Fibonacci f1 JOIN Fibonacci f2 ON f1.N = Fibonacci.N - 1 AND f2.N = Fibonacci.N)
    FROM Fibonacci
    WHERE N < 20
)
SELECT * FROM Fibonacci;

2. Strings where all characters are the same and len > 1
SELECT *
FROM FindSameCharacters
WHERE LEN(Vals) > 1
  AND Vals NOT LIKE '%[^' + LEFT(Vals, 1) + ']%';

3. Sequence like 1, 12, 123, ..., n
DECLARE @n INT = 5;
WITH NumCTE AS (
    SELECT 1 AS Num, CAST('1' AS VARCHAR(MAX)) AS Val
    UNION ALL
    SELECT Num + 1, Val + CAST(Num + 1 AS VARCHAR)
    FROM NumCTE
    WHERE Num < @n
)
SELECT * FROM NumCTE;

4. Employees with most sales in last 6 months
SELECT e.EmployeeID, e.FirstName, e.LastName, s.TotalSales
FROM Employees e
JOIN (
    SELECT TOP 1 EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
    ORDER BY SUM(SalesAmount) DESC
) s ON e.EmployeeID = s.EmployeeID;

5. Remove duplicate and single integer characters from string
SELECT PawanName,
       Pawan_slug_name,
       (SELECT STRING_AGG(val, '')
        FROM (
            SELECT val
            FROM (
                SELECT SUBSTRING(Pawan_slug_name, number, 1) AS val
                FROM master.dbo.spt_values
                WHERE type = 'P'
                  AND number BETWEEN 1 AND LEN(Pawan_slug_name)
            ) a
            WHERE val NOT LIKE '[0-9]'
               OR (LEN(REPLACE(Pawan_slug_name, val, '')) < LEN(Pawan_slug_name) - 1)
        ) b)
       AS CleanedName
FROM RemoveDuplicateIntsFromNames;
