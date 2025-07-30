Here are my answers to the questions: 

Easy-level tasks  
1. Split Name by Comma (TestMultipleColumns)
SELECT 
    LEFT(Name, CHARINDEX(',', Name) - 1) AS Name,
    LTRIM(RIGHT(Name, LEN(Name) - CHARINDEX(',', Name))) AS Surname
FROM TestMultipleColumns;
Explanation: We split Name into two parts using CHARINDEX to locate the comma.

2. Find strings that contain the % character (TestPercent)

SELECT * 
FROM TestPercent 
WHERE Value LIKE '%[%]%';
Explanation: % is a wildcard, so we wrap it in [] to treat it as a literal character.

3. Split a string using dot (.) (Splitter)
SELECT 
    value AS SplitPart 
FROM Splitter 
CROSS APPLY STRING_SPLIT(Value, '.');
Explanation: STRING_SPLIT separates string values by . into multiple rows.

4. Replace digits with 'X' (string: 1234ABC123456XYZ1234567890ADS)
SELECT 
    TRANSLATE(StringValue, '0123456789', 'XXXXXXXXXX') AS ReplacedString
FROM (SELECT '1234ABC123456XYZ1234567890ADS' AS StringValue) AS t;
Explanation: TRANSLATE replaces each digit with X.

5. Return rows where Vals contains more than 2 dots (testDots)
SELECT * 
FROM testDots 
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;
Explanation: We count the number of dots by checking the length difference.

6. Count the number of spaces in a string (CountSpaces)
SELECT 
    LEN(Value) - LEN(REPLACE(Value, ' ', '')) AS SpaceCount
FROM CountSpaces;
Explanation: Subtract length without spaces from original length.

7. Employees earning more than their managers (Employee)
SELECT e.EmployeeID, e.Name, e.Salary, e.ManagerID
FROM Employee e
JOIN Employee m ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;
Explanation: Self-join to compare employee's salary with their manager's.

8. Employees with 10–15 years of service (Employees)
SELECT 
    EmployeeID, FirstName, LastName, HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 11 AND 14;
Explanation: We calculate the number of years and filter between 11 and 14.

Medium-level tasks
1. Separate integer and character values into two columns (Input: 'rtcfvty34redt')

SELECT 
    STRING_AGG(CASE WHEN TRY_CAST(SUBSTRING(s.val, number, 1) AS INT) IS NULL 
                   THEN SUBSTRING(s.val, number, 1) ELSE '' END, '') AS CharsOnly,
    STRING_AGG(CASE WHEN TRY_CAST(SUBSTRING(s.val, number, 1) AS INT) IS NOT NULL 
                   THEN SUBSTRING(s.val, number, 1) ELSE '' END, '') AS DigitsOnly
FROM (SELECT 'rtcfvty34redt' AS val) s
JOIN master..spt_values n ON number BETWEEN 1 AND LEN(s.val)
WHERE type = 'P';
Explanation: Loops over each character, uses TRY_CAST to check if it's a digit, and then aggregates them separately.

2. Find dates with higher temperature than previous day (weather)
SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM weather w1
JOIN weather w2 ON DATEDIFF(DAY, w2.RecordDate, w1.RecordDate) = 1
WHERE w1.Temperature > w2.Temperature;
Explanation: We compare each day's temperature to the day before using a self-join.

3. First login date per player (Activity)
SELECT PlayerID, MIN(LoginDate) AS FirstLoginDate
FROM Activity
GROUP BY PlayerID;
Explanation: Simply aggregates the earliest login date per player.

4. Return the 3rd item from the list (fruits)
SELECT value AS ThirdItem
FROM (
    SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM fruits
    CROSS APPLY STRING_SPLIT(FruitList, ',')
) x
WHERE rn = 3;
Explanation: STRING_SPLIT breaks the list into parts, and ROW_NUMBER finds the third item.

5. Convert each character into a row (Input: 'sdgfhsdgfhs@121313131')
WITH chars AS (
    SELECT 1 AS n
    UNION ALL SELECT n + 1 FROM chars WHERE n < LEN('sdgfhsdgfhs@121313131')
)
SELECT SUBSTRING('sdgfhsdgfhs@121313131', n, 1) AS Char
FROM chars
OPTION (MAXRECURSION 100);
Explanation: A recursive CTE generates a position for each character to extract one character per row.

6. Join p1 and p2, replacing p1.code = 0 with p2.code
SELECT 
    p1.id,
    CASE 
        WHEN p1.code = 0 THEN p2.code 
        ELSE p1.code 
    END AS FinalCode
FROM p1
JOIN p2 ON p1.id = p2.id;
Explanation: Replaces p1.code with p2.code only if p1.code is 0.

7. Categorize employees into employment stages (Employees)
SELECT 
    EmployeeID, FirstName, LastName, HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;
Explanation: Uses a CASE statement to categorize employees based on their years of service.

8. Extract integer at the start of a string (GetIntegers)

SELECT 
    Vals,
    LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'a') - 1) AS LeadingInteger
FROM GetIntegers;
Explanation: Extracts the numeric prefix using PATINDEX to find the first non-digit character.

Next, I’ll solve the Difficult-level tasks with equally detailed SQL. Would you like me to continue?

Difficult-level Tasks

1. Swap the first two letters of a comma-separated string

SELECT 
  Val,
  -- Swap first and second item using SUBSTRING logic
  CONCAT(
    SUBSTRING(Val, CHARINDEX(',', Val) + 1, CHARINDEX(',', Val, CHARINDEX(',', Val) + 1) - CHARINDEX(',', Val) - 1), ',', -- second item
    LEFT(Val, CHARINDEX(',', Val) - 1), ',', -- first item
    RIGHT(Val, LEN(Val) - CHARINDEX(',', Val, CHARINDEX(',', Val) + 1)) -- rest
  ) AS Swapped
FROM MultipleVals
WHERE LEN(Val) - LEN(REPLACE(Val, ',', '')) >= 2;

This only works correctly when there are at least three comma-separated values. You can expand this logic with CHARINDEX and SUBSTRING if needed for more values.

2. Get the first device used by each player

SELECT player_id, device_id
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rn
    FROM Activity
) AS t
WHERE rn = 1;
Explanation: We use ROW_NUMBER() to rank login times and then select the first one.

3. Calculate week-on-week % of sales per area

SELECT 
  DATEPART(YEAR, sale_date) AS SaleYear,
  DATEPART(WEEK, sale_date) AS SaleWeek,
  area,
  DATENAME(WEEKDAY, sale_date) AS WeekDay,
  SUM(amount) AS TotalSales,
  ROUND(
    100.0 * SUM(amount) / 
    SUM(SUM(amount)) OVER (PARTITION BY DATEPART(YEAR, sale_date), DATEPART(WEEK, sale_date)),
    2
  ) AS PercentageOfWeek
FROM WeekPercentagePuzzle
GROUP BY 
  DATEPART(YEAR, sale_date),
  DATEPART(WEEK, sale_date),
  area,
  DATENAME(WEEKDAY, sale_date)
ORDER BY SaleYear, SaleWeek, area;









