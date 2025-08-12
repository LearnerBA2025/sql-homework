Here are my answers to the questions: 

1) Assign a row number to each sale based on the SaleDate.

Row number by SaleDate (earliest = 1). Tie-breaker uses SaleID.
SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    Quantity,
    CustomerID,
    ROW_NUMBER() OVER (ORDER BY SaleDate, SaleID) AS RowNum
FROM ProductSales
ORDER BY SaleDate, SaleID;
Explanation: ROW_NUMBER() enumerates rows in date order. SaleID breaks ties on same date.

2) Rank products based on the total quantity sold — give same rank for same totals without skipping numbers.

Calculate total quantity per product and assign a dense rank (no gaps for ties)
SELECT
    ProductName,
    TotalQuantity,
    DENSE_RANK() OVER (ORDER BY TotalQuantity DESC) AS QuantityRank
FROM (
    SELECT ProductName, SUM(Quantity) AS TotalQuantity
    FROM ProductSales
    GROUP BY ProductName
) t
ORDER BY TotalQuantity DESC;
Explanation: DENSE_RANK() gives identical ranks for equal totals and does not skip rank numbers.

3) Identify the top sale for each customer based on SaleAmount.

If a customer has multiple highest-equal sales, this returns the latest by SaleDate (tie-breaker)
WITH ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC, SaleDate DESC, SaleID DESC) AS rn
  FROM ProductSales
)
SELECT SaleID, CustomerID, ProductName, SaleDate, SaleAmount, Quantity
FROM ranked
WHERE rn = 1
ORDER BY CustomerID;
Explanation: PARTITION BY CustomerID + ORDER BY SaleAmount DESC picks the top sale per customer. ROW_NUMBER() keeps a single row per customer (tie-breakers: date, SaleID).

4) Display each sale's amount along with the next sale amount in order of SaleDate.

SELECT
  SaleID,
  SaleDate,
  SaleAmount,
  LEAD(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS NextSaleAmount
FROM ProductSales
ORDER BY SaleDate, SaleID;
Explanation: LEAD() returns the next row’s SaleAmount according to the date order; last row will have NULL.

5) Display each sale's amount along with the previous sale amount in order of SaleDate.

SELECT
  SaleID,
  SaleDate,
  SaleAmount,
  LAG(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS PrevSaleAmount
FROM ProductSales
ORDER BY SaleDate, SaleID;

6) Identify sales amounts that are greater than the previous sale's amount (global by date).

WITH t AS (
  SELECT *,
         LAG(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS PrevAmt
  FROM ProductSales
)
SELECT SaleID, SaleDate, SaleAmount, PrevAmt
FROM t
WHERE PrevAmt IS NOT NULL
  AND SaleAmount > PrevAmt
ORDER BY SaleDate, SaleID;
Explanation: We compare each sale to the immediately preceding one (by SaleDate). First row has NULL previous — excluded.

7) Calculate the difference in sale amount from the previous sale for every product (per-product).

SELECT
  SaleID,
  ProductName,
  SaleDate,
  SaleAmount,
  SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) AS DiffFromPrev
FROM ProductSales
ORDER BY ProductName, SaleDate;
Explanation: Partitioning by ProductName ensures comparisons only within the same product.

8) Compare the current sale amount with the next sale amount in terms of percentage change.

Global (across all products by date):

SELECT
  SaleID,
  SaleDate,
  SaleAmount,
  LEAD(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS NextSaleAmount,
  CASE
    WHEN SaleAmount = 0 THEN NULL
    ELSE ROUND((LEAD(SaleAmount) OVER (ORDER BY SaleDate, SaleID) - SaleAmount) * 100.0 / SaleAmount, 2)
  END AS PctChangeToNext
FROM ProductSales
ORDER BY SaleDate, SaleID;

  Per-product (compare to next sale of the same product):

SELECT
  SaleID,
  ProductName,
  SaleDate,
  SaleAmount,
  LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) AS NextSaleAmount,
  CASE
    WHEN SaleAmount = 0 THEN NULL
    ELSE ROUND((LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) - SaleAmount) * 100.0 / SaleAmount, 2)
  END AS PctChangeToNextWithinProduct
FROM ProductSales
ORDER BY ProductName, SaleDate;
Explanation: (next - current) / current * 100. NULL when division by zero or no next sale.

9) Calculate the ratio of the current sale amount to the previous sale amount within the same product.

WITH prev AS (
  SELECT *,
         LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) AS PrevAmt
  FROM ProductSales
)
SELECT
  SaleID,
  ProductName,
  SaleDate,
  SaleAmount,
  CASE
    WHEN PrevAmt IS NULL OR PrevAmt = 0 THEN NULL
    ELSE CAST(SaleAmount / PrevAmt AS DECIMAL(10,4))
  END AS RatioToPrev
FROM prev
ORDER BY ProductName, SaleDate;
Explanation: Ratio = current / previous. NULL if previous doesn't exist or is 0.

10) Calculate the difference in sale amount from the very first sale of that product.

SELECT
  SaleID,
  ProductName,
  SaleDate,
  SaleAmount,
  SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) AS DiffFromFirstSale
FROM ProductSales
ORDER BY ProductName, SaleDate;
Explanation: FIRST_VALUE() gives the first sale for each product (by date). Subtract to get difference.

11) Find products whose sales are strictly increasing for every successive sale (each sale > previous).

Query that returns product names which have a strictly increasing sequence:

WITH t AS (
  SELECT ProductName,
         SaleAmount,
         LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) AS PrevAmt
  FROM ProductSales
)
SELECT ProductName
FROM t
GROUP BY ProductName
HAVING SUM(CASE WHEN PrevAmt IS NOT NULL AND SaleAmount <= PrevAmt THEN 1 ELSE 0 END) = 0;
If you want the actual rows for those products (all sales listed):

SELECT ps.*
FROM ProductSales ps
WHERE ps.ProductName IN (
  WITH t AS (
    SELECT ProductName,
           SaleAmount,
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) AS PrevAmt
    FROM ProductSales
  )
  SELECT ProductName
  FROM t
  GROUP BY ProductName
  HAVING SUM(CASE WHEN PrevAmt IS NOT NULL AND SaleAmount <= PrevAmt THEN 1 ELSE 0 END) = 0
)
ORDER BY ProductName, SaleDate;
Explanation: We check for any violation SaleAmount <= PrevAmt. If zero violations, product's sales are strictly increasing.

12) Calculate a "closing balance" (running total) for sales amounts — cumulative sum of SaleAmount.

Global running total by date:

SELECT
  SaleID,
  SaleDate,
  SaleAmount,
  SUM(SaleAmount) OVER (ORDER BY SaleDate, SaleID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM ProductSales
ORDER BY SaleDate, SaleID;
Per-product running total (separate cumulative totals per product):

SELECT
  SaleID,
  ProductName,
  SaleDate,
  SaleAmount,
  SUM(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotalPerProduct
FROM ProductSales
ORDER BY ProductName, SaleDate;

13) Calculate the moving average of sales amounts over the last 3 sales.

Global 3-sale moving average by date (current + previous 2):

SELECT
  SaleID,
  SaleDate,
  SaleAmount,
  AVG(SaleAmount) OVER (ORDER BY SaleDate, SaleID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg_Last3
FROM ProductSales
ORDER BY SaleDate, SaleID;
Per-product 3-sale moving average:

SELECT
  SaleID,
  ProductName,
  SaleDate,
  SaleAmount,
  AVG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg_Last3_PerProduct
FROM ProductSales
ORDER BY ProductName, SaleDate;
Explanation: The frame 2 PRECEDING includes the current row + previous 2 rows (fewer rows for the first 1–2 entries).

14) Show the difference between each sale amount and the average sale amount (overall table average).

SELECT
  SaleID,
  SaleDate,
  SaleAmount,
  SaleAmount - AVG(SaleAmount) OVER () AS DiffFromOverallAvg
FROM ProductSales
ORDER BY SaleDate, SaleID;
Explanation: AVG(...) OVER() computes the overall average once; subtracting gives the difference per sale.

Employees1 — window / analytic solutions
Run the CREATE TABLE Employees1 and INSERT you provided, then these queries.

15) Find employees who have the same salary rank (i.e., identical salary).

WITH salary_ranks AS (
  SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
  FROM Employees1
)
SELECT
  SalaryRank,
  Salary,
  STRING_AGG(Name, ', ') WITHIN GROUP (ORDER BY EmployeeID) AS EmployeesWithThatSalary,
  COUNT(*) AS NumEmployees
FROM salary_ranks
GROUP BY SalaryRank, Salary
HAVING COUNT(*) > 1
ORDER BY Salary DESC;
Explanation: DENSE_RANK() groups equal salaries to the same rank. HAVING COUNT(*) > 1 shows ranks shared by multiple employees.

16) Identify the top 2 highest salaries in each department.

Option 1 — exactly two rows per department (useful when you must limit to two rows even if there are ties):

SELECT * FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC, HireDate) AS rn
  FROM Employees1
) t
WHERE rn <= 2
ORDER BY Department, rn;
Option 2 — include ties for the 2nd place (use RANK so ties are included):

SELECT *
FROM (
  SELECT *,
         RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
  FROM Employees1
) t
WHERE rnk <= 2
ORDER BY Department, rnk;
Explanation: ROW_NUMBER() selects exactly 2 rows per department; RANK() includes all tied salaries that fall into the top-2 ranks.

17) Find the lowest-paid employee in each department.

SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC, HireDate) AS rn
  FROM Employees1
) t
WHERE rn = 1
ORDER BY Department;
Note: If you want all employees tied for the lowest salary, replace ROW_NUMBER() with RANK() and filter rnk = 1 to include ties.

18) Calculate the running total of salaries in each department (ordered by HireDate).

SELECT
  EmployeeID,
  Name,
  Department,
  Salary,
  HireDate,
  SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningDeptSalary
FROM Employees1
ORDER BY Department, HireDate;
Explanation: Cumulative sum in each department as you move forward by HireDate.

19) Find the total salary of each department without GROUP BY.

SELECT DISTINCT
  Department,
  SUM(Salary) OVER (PARTITION BY Department) AS TotalSalaryByDept
FROM Employees1
ORDER BY Department;
Explanation: SUM(...) OVER (PARTITION BY Department) computes department totals on every row; DISTINCT collapses to one row per department.

20) Calculate the average salary in each department without GROUP BY.

SELECT DISTINCT
  Department,
  AVG(Salary) OVER (PARTITION BY Department) AS AvgSalaryByDept
FROM Employees1
ORDER BY Department;

 21) Find the difference between an employee’s salary and their department’s average.

SELECT
  EmployeeID,
  Name,
  Department,
  Salary,
  Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1
ORDER BY Department, Name;
Explanation: Positive value = above department average; negative = below.

22) Calculate the moving average salary over 3 employees (including current, previous, and next).

Per-department moving average ordered by HireDate (frame: previous 1, current, next 1):

SELECT
  EmployeeID,
  Name,
  Department,
  Salary,
  HireDate,
  AVG(Salary) OVER (
     PARTITION BY Department
     ORDER BY HireDate
     ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS MovingAvg_3Employees
FROM Employees1
ORDER BY Department, HireDate;
Explanation: For each employee this averages their salary with the previous and next hire in the same department (where those exist). If previous or next doesn't exist, it averages available rows.

23) Find the sum of salaries for the last 3 hired employees.

WITH hirechronology AS (
  SELECT *, 
         ROW_NUMBER() OVER (ORDER BY hiredate DESC) AS rn
  FROM employees1
)
SELECT SUM(salary) AS SumLast3Hired
FROM hirechronology
WHERE rn <= 3;
