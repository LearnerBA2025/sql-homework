Here are my answers to the questions:
  
Puzzle 1: Finding Distinct Values Based on Two Columns

Goal:
Return only one row for each unique (col1, col2) pair, regardless of order (e.g., 'a'-'b' and 'b'-'a' are considered the same).

Method 1: Use CASE to order values consistently and then select DISTINCT

SELECT DISTINCT
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;

Method 2: Use MIN() and MAX() for pair normalization

SELECT DISTINCT
    MIN(col1) AS col1,
    MAX(col2) AS col2
FROM InputTbl
GROUP BY 
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END;
Output:
col1	col2
a	b
c	d
m	n

Puzzle 2: Removing Rows with All Zeroes
Goal:
Exclude rows where all columns are 0.

SQL Server Query:

SELECT *
FROM TestMultipleZero
WHERE NOT (
    ISNULL(A, 0) = 0 AND 
    ISNULL(B, 0) = 0 AND 
    ISNULL(C, 0) = 0 AND 
    ISNULL(D, 0) = 0
);
You could also write:


SELECT *
FROM TestMultipleZero
WHERE A + B + C + D <> 0;
This works because if all values are zero, the sum will be 0.

Puzzle 3: Find People with Odd IDs

SELECT *
FROM section1
WHERE id % 2 = 1;
🎯 Output:
id	name
1	Been
3	Steven
5	Genryh
7	Fred

Puzzle 4: Person with the Smallest ID

SELECT TOP 1 *
FROM section1
ORDER BY id ASC;
Or use:


SELECT *
FROM section1
WHERE id = (SELECT MIN(id) FROM section1);

Puzzle 5: Person with the Highest ID

SELECT TOP 1 *
FROM section1
ORDER BY id DESC;
Or:


SELECT *
FROM section1
WHERE id = (SELECT MAX(id) FROM section1);

Puzzle 6: People Whose Name Starts with ‘b’ (case-insensitive)

SELECT *
FROM section1
WHERE name LIKE 'b%';
If case sensitivity matters (depending on collation), you may write:


WHERE LOWER(name) LIKE 'b%'
Puzzle 7: Find Rows Where Code Contains a Literal Underscore _
In SQL Server, the underscore _ is normally a wildcard for any one character. To search for the literal underscore, you must escape it.

SELECT *
FROM ProductCodes
WHERE Code LIKE '%\_%' ESCAPE '\';
