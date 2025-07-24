Here are my answers to the questions:

EASY TASKS
1. Display "100-Steven King" using Employees table (emp_id + first_name + last_name)

SELECT 
    CAST(emp_id AS VARCHAR) + '-' + first_name + ' ' + last_name AS EmployeeInfo
FROM employees
WHERE emp_id = 100;

We concatenate using +, cast emp_id to string, and add dashes and spaces for formatting.

2. Replace '124' with '999' in phone_number column

UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

This uses the REPLACE() function to update all matches of '124'.

3. First name + its length for names starting with A, J, or M

SELECT 
    first_name AS [First Name],
    LEN(first_name) AS [Name Length]
FROM employees
WHERE LEFT(first_name, 1) IN ('A', 'J', 'M')
ORDER BY first_name;
LEFT() checks the first character. LEN() gives the name length. Sorted alphabetically.

4. Total salary for each manager ID

SELECT 
    manager_id,
    SUM(salary) AS TotalSalary
FROM employees
GROUP BY manager_id;
Group by manager_id and sum the salary.

5. From TestMax, get year + highest value across Max1, Max2, Max3 for each row

select year1, 
case when Max1 >= Max2 and Max1>=Max3 then Max1
when Max2 >=Max3 and Max2 >=Max1 then Max2 
else Max3 end as highest_value from TestMax

6. Odd-numbered movies, where description ≠ 'boring'

SELECT *
FROM cinema
WHERE id % 2 = 1 AND description <> 'boring';
Odd-numbered id means id % 2 = 1.
  
7. Sort by ID, but 0 always comes last

SELECT *
FROM SingleOrder
ORDER BY 
    CASE WHEN id = 0 THEN 1 ELSE 0 END,
    id;

We artificially push id=0 to the bottom using a CASE sort override.

8. Return first non-null value from a set of columns (Person table)

SELECT 
    COALESCE(col1, col2, col3, col4) AS FirstNonNull
FROM person;
COALESCE() returns the first non-null column value in order.

MEDIUM TASKS
1. Split FullName into Firstname, Middlename, Lastname (Students Table)

select left(FullName, CHARINDEX(' ', FullName) - 1),
substring(fullname, charindex (' ', Fullname)+1, Len (fullname) - CHARINDEX(' ', FullName) - charindex(' ', reverse(fullname))) as middle_name,
right(fullname, charindex(' ', reverse(fullname))-1) as last_name from students

2. Customers who had a delivery to California → show their orders to Texas (Orders Table)

SELECT *
FROM Orders
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE delivery_state = 'California'
)
AND delivery_state = 'Texas';
We filter customers who also had Texas orders using a WHERE IN subquery.

3. Group concatenate values (DMLTable)

SELECT STRING_AGG(String, ' ') 
       WITHIN GROUP (ORDER BY SequenceNumber) AS FullQuery
FROM DMLTable;

4. Employees where full name contains at least 3 “a” letters

SELECT *
FROM employees
WHERE 
    LEN(first_name + last_name) 
    - LEN(REPLACE(first_name + last_name, 'a', '')) >= 3;
We count occurrences by comparing length before and after removing "a"s.

5. Number of employees per department + % with >3 years

SELECT 
    CAST(100.0 * 
        SUM(CASE WHEN Hire_Date <= DATEADD(YEAR, -3, GETDATE()) THEN 1 ELSE 0 END) 
        / COUNT(*) AS DECIMAL(5,2)
    ) AS Percent_Over_3_Years
FROM employees;

6. Most and least experienced SpacemanID per JobDescription (Personal)

SELECT 
    p.JobDescription,
    most.SpacemanID AS MostExperiencedSpaceman,
    most.MissionCount AS MostMissions,
    least.SpacemanID AS LeastExperiencedSpaceman,
    least.MissionCount AS LeastMissions
FROM (SELECT DISTINCT JobDescription FROM personal) p
CROSS APPLY (
    SELECT TOP 1 SpacemanID, MissionCount
    FROM personal
    WHERE personal.JobDescription = p.JobDescription
    ORDER BY MissionCount DESC
) most
CROSS APPLY (
    SELECT TOP 1 SpacemanID, MissionCount
    FROM personal
    WHERE personal.JobDescription = p.JobDescription
    ORDER BY MissionCount ASC
) least;
We use CROSS APPLY to get top 1 highest and lowest MissionCount for each job.


DIFFICULT TASKS 
  
  Difficult Task 1
  
 SELECT 
  'tf56sd#%OqH' AS OriginalString,

  -- UPPERCASE letters 
  CONCAT(
    IIF(SUBSTRING('tf56sd#%OqH', 1, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 1, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 2, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 2, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 3, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 3, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 4, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 4, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 5, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 5, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 6, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 6, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 7, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 7, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 8, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 8, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 9, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 9, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 10, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 10, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 11, 1) LIKE '[A-Z]', SUBSTRING('tf56sd#%OqH', 11, 1), '')
  ) AS UppercaseLetters,

  -- lowercase letters
  CONCAT(
    IIF(SUBSTRING('tf56sd#%OqH', 1, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 1, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 2, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 2, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 3, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 3, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 4, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 4, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 5, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 5, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 6, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 6, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 7, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 7, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 8, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 8, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 9, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 9, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 10, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 10, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 11, 1) LIKE '[a-z]', SUBSTRING('tf56sd#%OqH', 11, 1), '')
  ) AS LowercaseLetters,

  -- Digits
  CONCAT(
    IIF(SUBSTRING('tf56sd#%OqH', 1, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 1, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 2, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 2, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 3, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 3, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 4, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 4, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 5, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 5, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 6, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 6, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 7, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 7, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 8, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 8, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 9, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 9, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 10, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 10, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 11, 1) LIKE '[0-9]', SUBSTRING('tf56sd#%OqH', 11, 1), '')
  ) AS Digits,

  -- Symbols (not a-z, A-Z, 0-9)
  CONCAT(
    IIF(SUBSTRING('tf56sd#%OqH', 1, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 1, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 2, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 2, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 3, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 3, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 4, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 4, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 5, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 5, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 6, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 6, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 7, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 7, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 8, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 8, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 9, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 9, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 10, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 10, 1), ''),
    IIF(SUBSTRING('tf56sd#%OqH', 11, 1) NOT LIKE '[a-zA-Z0-9]', SUBSTRING('tf56sd#%OqH', 11, 1), '')
  ) AS Symbols;


Difficult Task 2


SELECT 
  S1.StudentID,
  S1.grade,
  (SELECT SUM(S2.grade) 
   FROM Students S2 
   WHERE S2.StudentID <= S1.StudentID) AS CumulativeScore
FROM Students S1
ORDER BY S1.StudentID;


Difficult Task 3

 SELECT
    Equation,
  
  -- Split numbers and add them using string functions
  CAST(LEFT(Equation, CHARINDEX('+', Equation + '+') - 1) AS INT) +
  
  IIF(CHARINDEX('+', Equation + '+') = 0, 0,
      CAST(
        SUBSTRING(
          Equation,
          CHARINDEX('+', Equation + '+') + 1,
          CHARINDEX('+', Equation + '+', CHARINDEX('+', Equation + '+') + 1) - CHARINDEX('+', Equation + '+') - 1
        ) AS INT)
     ) +
     
  IIF(LEN(Equation) - LEN(REPLACE(Equation, '+', '')) >= 2,
      CAST(RIGHT(Equation, CHARINDEX('+', REVERSE(Equation) + '+') - 1) AS INT),
      0
  ) AS Total
FROM Equations;



Difficult Task 4
SELECT 
  S1.StudentID,
  S1.FullName,
  S1.BirthDate
FROM Students S1
JOIN (
    SELECT DAY(BirthDate) AS BD_Day, MONTH(BirthDate) AS BD_Month
    FROM Students
    GROUP BY DAY(BirthDate), MONTH(BirthDate)
    HAVING COUNT(*) > 1
) Dups
ON DAY(S1.BirthDate) = Dups.BD_Day AND MONTH(S1.BirthDate) = Dups.BD_Month;

Difficult Task 5

SELECT 
  CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
  CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
  SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
  CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
  CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END;



