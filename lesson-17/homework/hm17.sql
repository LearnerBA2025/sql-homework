Here are my answers to the questions: 

1. Distributors Sales Report by Region (Missing combinations get 0)
SELECT 
    r.Region,
    d.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM
    (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN
    (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN
    #RegionSales rs
    ON rs.Region = r.Region AND rs.Distributor = d.Distributor
ORDER BY
    d.Distributor, r.Region;
2. Managers with At Least 5 Direct Reports
SELECT e.name
FROM Employee e
JOIN (
    SELECT managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) mgr ON e.id = mgr.managerId;

3. Products With At Least 100 Units Ordered in February 2020

SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

4. Vendor with Most Orders per Customer

WITH VendorOrders AS (
    SELECT 
        CustomerID,
        Vendor,
        COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID, Vendor
),
RankedVendors AS (
    SELECT *,
           RANK() OVER (PARTITION BY CustomerID ORDER BY OrderCount DESC) AS rnk
    FROM VendorOrders
)
SELECT CustomerID, Vendor
FROM RankedVendors
WHERE rnk = 1;

5. Check if a Number is Prime (Using WHILE Loop)

DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @isPrime BIT = 1;

IF @Check_Prime <= 1
    SET @isPrime = 0;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @isPrime = 0;
        BREAK;
    END
    SET @i = @i + 1;
END

IF @isPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

6. Device Signals Summary per Device

WITH LocationStats AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS SignalCount
    FROM Device
    GROUP BY Device_id, Locations
),
Ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY Device_id ORDER BY SignalCount DESC) AS rnk
    FROM LocationStats
),
MaxLocation AS (
    SELECT Device_id, Locations AS max_signal_location
    FROM Ranked
    WHERE rnk = 1
)
SELECT 
    d.Device_id,
    COUNT(DISTINCT d.Locations) AS no_of_location,
    m.max_signal_location,
    COUNT(*) AS no_of_signals
FROM Device d
JOIN MaxLocation m ON d.Device_id = m.Device_id
GROUP BY d.Device_id, m.max_signal_location;

7. Employees Earning More Than Department Average

WITH DeptAvg AS (
    SELECT DeptID, AVG(Salary) AS avg_salary
    FROM Employee
    GROUP BY DeptID
)
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN DeptAvg d ON e.DeptID = d.DeptID
WHERE e.Salary > d.avg_salary;

8. Lottery Winning Amounts

WITH Matched AS (
    SELECT t.TicketID, COUNT(*) AS match_count
    FROM Tickets t
    JOIN Numbers n ON t.Number = n.Number
    GROUP BY t.TicketID
)
SELECT SUM(
    CASE 
        WHEN match_count = 3 THEN 100
        WHEN match_count >= 1 THEN 10
        ELSE 0
    END
) AS Total_Winnings
FROM Matched;

9. Mobile, Desktop, Both Spending by Date

WITH SpendPivot AS (
    SELECT 
        User_id,
        Spend_date,
        MAX(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS Used_Mobile,
        MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS Used_Desktop,
        SUM(Amount) AS Total_Amount
    FROM Spending
    GROUP BY User_id, Spend_date
)
SELECT 
    Spend_date,
    'Mobile' AS Platform,
    SUM(CASE WHEN Used_Mobile = 1 AND Used_Desktop = 0 THEN Total_Amount ELSE 0 END) AS Total_Amount,
    COUNT(DISTINCT CASE WHEN Used_Mobile = 1 AND Used_Desktop = 0 THEN User_id END) AS Total_users
FROM SpendPivot
GROUP BY Spend_date

UNION ALL

SELECT 
    Spend_date,
    'Desktop',
    SUM(CASE WHEN Used_Desktop = 1 AND Used_Mobile = 0 THEN Total_Amount ELSE 0 END),
    COUNT(DISTINCT CASE WHEN Used_Desktop = 1 AND Used_Mobile = 0 THEN User_id END)
FROM SpendPivot
GROUP BY Spend_date

UNION ALL

SELECT 
    Spend_date,
    'Both',
    SUM(CASE WHEN Used_Desktop = 1 AND Used_Mobile = 1 THEN Total_Amount ELSE 0 END),
    COUNT(DISTINCT CASE WHEN Used_Desktop = 1 AND Used_Mobile = 1 THEN User_id END)
FROM SpendPivot
GROUP BY Spend_date
ORDER BY Spend_date, Platform;

10. De-Group Table Rows by Quantity

WITH Numbers AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
),
Expanded AS (
    SELECT g.Product, 1 AS Quantity
    FROM Grouped g
    JOIN Numbers n ON n.n <= g.Quantity
)
SELECT * FROM Expanded
ORDER BY Product;
