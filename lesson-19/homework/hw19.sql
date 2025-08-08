Here are my answers to the questions: 

Task 1: Stored Procedure – #EmployeeBonus
CREATE PROCEDURE GetEmployeeBonus
AS
BEGIN
    -- Step 1: Create temp table
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(101),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    -- Step 2: Insert calculated data
    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID,
        CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
        e.Department,
        e.Salary,
        e.Salary * db.BonusPercentage / 100 AS BonusAmount
    FROM Employees e
    JOIN DepartmentBonus db ON e.Department = db.Department;

    -- Step 3: Show results
    SELECT * FROM #EmployeeBonus;
END;
To test it:
EXEC GetEmployeeBonus;

Task 2: Stored Procedure – Salary Update by Department
CREATE PROCEDURE UpdateDepartmentSalaries
    @Department NVARCHAR(50),
    @IncreasePercent DECIMAL(5,2)
AS
BEGIN
    -- Step 1: Update salaries
    UPDATE Employees
    SET Salary = Salary * (1 + @IncreasePercent / 100)
    WHERE Department = @Department;

    -- Step 2: Return updated employees
    SELECT * 
    FROM Employees
    WHERE Department = @Department;
END;
To test it (e.g., increase Sales by 10%):
EXEC UpdateDepartmentSalaries @Department = 'Sales', @IncreasePercent = 10;

Task 3: MERGE Products
MERGE INTO Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID
WHEN MATCHED THEN 
    UPDATE SET 
        target.ProductName = source.ProductName,
        target.Price = source.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

-- Final result
SELECT * FROM Products_Current;

Task 4: Tree Node Types (Root, Inner, Leaf)
SELECT 
    id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree
ORDER BY id;

Task 5: Confirmation Rate
SELECT 
    s.user_id,
    CAST(
        1.0 * COUNT(CASE WHEN c.action = 'confirmed' THEN 1 END) / 
        NULLIF(COUNT(c.user_id), 0) AS DECIMAL(4,2)
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id;

Task 6: Find Employees with the Lowest Salary
SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

Task 7: Stored Procedure – GetProductSalesSummary
CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantitySold,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
To test it (e.g., for ProductID = 1):

EXEC GetProductSalesSummary @ProductID = 1;
