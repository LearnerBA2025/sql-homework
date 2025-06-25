Here are my answers to the homework questions:
Basic-Level Tasks (1–10)
1. Create a table Employees with columns:
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);
This creates a table with 3 columns: an integer ID, a name with max 50 letters, and a salary with 2 decimal places.

2. Insert 3 records using different INSERT INTO styles:
First, insert one row:
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Alice', 6000.00);

Then insert multiple rows in one shot:

INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
(2, 'Bob', 5500.00),
(3, 'Charlie', 5000.00);

3. Update salary of employee where EmpID = 1:
UPDATE Employees
SET Salary = 7000.00
WHERE EmpID = 1;
This changes Alice’s salary to 7000.

4. Delete record where EmpID = 2:
DELETE FROM Employees
WHERE EmpID = 2;
Bob will be removed from the table.

5. Difference between DELETE, TRUNCATE, and DROP:
DELETE: Removes selected rows from a table. You can use WHERE. The table structure stays.

TRUNCATE: Removes all rows quickly. You can't use WHERE. The table stays, but it’s empty.

DROP: Completely deletes the table itself—data + structure. It’s gone.

Simple analogy:
DELETE is like removing some clothes from your closet.
TRUNCATE is like emptying the whole closet.
DROP is like throwing the entire closet away.

6. Modify Name column to hold up to 100 characters:

ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

7. Add a new column Department:

ALTER TABLE Employees
ADD Department VARCHAR(50);
8. Change Salary data type to FLOAT:

ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;
9. Create Departments table:

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
10. Remove all records from Employees table (keep structure):

DELETE FROM Employees;
or

TRUNCATE TABLE Employees;
We can use DELETE if we need rollback or logging.
We can use TRUNCATE if we want faster performance.

Intermediate-Level Tasks (11–16)
11. Insert 5 records into Departments using INSERT INTO SELECT:
Let’s first create a dummy source table:

CREATE TABLE TempDepartments (
    DepartmentID INT,
    DepartmentName VARCHAR(50)
);

INSERT INTO TempDepartments VALUES
(1, 'HR'), (2, 'IT'), (3, 'Finance'), (4, 'Marketing'), (5, 'Support');
Now insert into Departments from this:

INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT DepartmentID, DepartmentName FROM TempDepartments;
12. Update employees with Salary > 5000 to “Management”:

UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;
13. Remove all employees but keep table:


DELETE FROM Employees;
or

TRUNCATE TABLE Employees;
14. Drop the Department column from Employees:

ALTER TABLE Employees
DROP COLUMN Department;
15. Rename Employees table to StaffMembers:


EXEC sp_rename 'Employees', 'StaffMembers';
Works in SQL Server. 

In MySQL, we can use:

RENAME TABLE Employees TO StaffMembers;
16. Drop Departments table completely:

DROP TABLE Departments;

Advanced-Level Tasks (17–25)
17. Create Products table with 5 columns:

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Description VARCHAR(255)
);
18. Add a CHECK constraint for Price > 0:

ALTER TABLE Products
ADD CONSTRAINT CHK_Price CHECK (Price > 0);
19. Add StockQuantity column with default 50:

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;
20. Rename Category column to ProductCategory:
SQL Server:

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';
MySQL:

ALTER TABLE Products
CHANGE Category ProductCategory VARCHAR(50);
21. Insert 5 records into Products:

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES
(1, 'Laptop', 'Electronics', 1200.00, '14-inch screen'),
(2, 'Phone', 'Electronics', 800.00, '5G smartphone'),
(3, 'Desk Chair', 'Furniture', 150.00, 'Ergonomic chair'),
(4, 'Notebook', 'Stationery', 5.00, '100 pages'),
(5, 'Water Bottle', 'Kitchen', 12.50, 'Stainless steel');
22. Create a backup table Products_Backup:

SELECT * INTO Products_Backup
FROM Products;
23. Rename Products to Inventory:
SQL Server:

EXEC sp_rename 'Products', 'Inventory';
MySQL:

RENAME TABLE Products TO Inventory;
24. Change Price data type to FLOAT:

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;
25. Add ProductCode as IDENTITY, start from 1000, step by 5:
SQL Server doesn’t allow adding an identity column directly. So you'd need to recreate the table:

-- Step 1: Create a new table with IDENTITY
CREATE TABLE Inventory_New (
    ProductCode INT IDENTITY(1000,5),
    ProductID INT,
    ProductName VARCHAR(100),
    ProductCategory VARCHAR(50),
    Price FLOAT,
    Description VARCHAR(255),
    StockQuantity INT
);

-- Step 2: Copy data from old table
INSERT INTO Inventory_New (ProductID, ProductName, ProductCategory, Price, Description, StockQuantity)
SELECT ProductID, ProductName, ProductCategory, Price, Description, StockQuantity FROM Inventory;

-- Step 3: Drop old table and rename new one
DROP TABLE Inventory;
EXEC sp_rename 'Inventory_New', 'Inventory';
