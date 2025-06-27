Below are my answers to the homework questions: 
  
1. Define and explain the purpose of BULK INSERT in SQL Server.
BULK INSERT is a command in SQL Server used to quickly load large amounts of data from an external file (like a .csv or .txt) into a table. 
It’s useful when you want to import raw data (for example, from Excel or other systems) directly into a SQL Server table without manually typing each record. It's especially handy for big datasets.

2. List four file formats that can be imported into SQL Server.
You can import many file types, but four commonly used ones are:

CSV (.csv – comma-separated values)

TXT (.txt – plain text)

XML (.xml – structured data files)

JSON (.json – JavaScript Object Notation)

3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);
4. Insert three records into the Products table using INSERT INTO.
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
(1, 'Laptop', 999.99),
(2, 'Mouse', 25.50),
(3, 'Keyboard', 45.00);

5. Explain the difference between NULL and NOT NULL.
NULL means "no value" or "unknown". It's a placeholder showing that no data has been entered in that column.

NOT NULL means the column must have a value; you cannot leave it empty when inserting data.

6. Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products
ADD CONSTRAINT uq_ProductName UNIQUE (ProductName);
This ensures that each product name in the table is unique – no two rows can have the same product name.

7. Write a comment in a SQL query explaining its purpose.
-- This query retrieves all products with a price greater than 100
SELECT * FROM Products
WHERE Price > 100;

8. Add CategoryID column to the Products table.

ALTER TABLE Products
ADD CategoryID INT;

9. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

10. Explain the purpose of the IDENTITY column in SQL Server.
The IDENTITY column automatically generates a unique number for each new row. It’s commonly used for primary keys. 
For example, IDENTITY(1,1) starts from 1 and adds 1 for each new row. It saves you from manually entering unique IDs.

🟠 Medium-Level Tasks (10)
11. Use BULK INSERT to import data from a text file into the Products table.

BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
This assumes the text file is CSV-like, with comma-separated fields and a header row.

12. Create a FOREIGN KEY in the Products table that references the Categories table.

ALTER TABLE Products
ADD CONSTRAINT fk_Category
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);

13. Explain the differences between PRIMARY KEY and UNIQUE KEY.
A PRIMARY KEY uniquely identifies each row and does not allow NULLs.

A UNIQUE KEY also ensures uniqueness but can allow one NULL (depending on SQL Server version and configuration).

A table can have only one PRIMARY KEY but multiple UNIQUE constraints.

14. Add a CHECK constraint to the Products table ensuring Price > 0.

ALTER TABLE Products
ADD CONSTRAINT chk_Price CHECK (Price > 0);

15. Modify the Products table to add a column Stock (INT, NOT NULL).

ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;
Note: Adding DEFAULT 0 ensures existing rows don’t break due to the NOT NULL rule.

16. Use the ISNULL function to replace NULL values in Price column with a 0.

SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

17. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
A FOREIGN KEY connects two tables by linking a column in one table to the PRIMARY KEY of another. It ensures referential integrity, meaning you can't insert a value in the child table that doesn’t exist in the parent table. It helps avoid orphan records.

🔴 Hard-Level Tasks (10)
18. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Age INT CHECK (Age >= 18)
);
19. Create a table with an IDENTITY column starting at 100 and incrementing by 10.

CREATE TABLE SampleTable (
    ID INT IDENTITY(100, 10) PRIMARY KEY,
    Description VARCHAR(50)
);
The first row will get ID = 100, the next 110, then 120, and so on.

20. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);
A composite key means the combination of OrderID and ProductID must be unique.

21. Explain the use of COALESCE and ISNULL functions for handling NULL values.
ISNULL(expression, replacement) replaces a NULL with a specified value. It's simple and works with two arguments only.

COALESCE(expr1, expr2, ..., exprN) returns the first non-NULL value from the list. It’s more flexible and can take many arguments.

Example:

SELECT ISNULL(NULL, 'Default')         -- Returns 'Default'
SELECT COALESCE(NULL, NULL, 'Hello')   -- Returns 'Hello'

22. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);
23. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.

ALTER TABLE Products
ADD CONSTRAINT fk_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID)
ON DELETE CASCADE
ON UPDATE CASCADE;
This means:

If a Category is deleted, its related Products are also deleted.

If a CategoryID is updated, that change reflects in the Products table too.

