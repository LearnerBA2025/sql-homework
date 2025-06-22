Below are the answers from Bekzod Abdiyev for the 1st homework questions:
1. Define the following terms: data, database, relational database, and table.
Data: Data is information that can be collected, stored, and analyzed. It can be numbers, text, images, or other types of information. For example, a list of student names and grades is data.

Database: A database is an organized collection of data that can be easily accessed, managed, and updated. It helps store large amounts of data efficiently.

Relational Database: This is a type of database that stores data in related tables. Each table contains rows and columns, and relationships between tables are defined using keys (like foreign keys).

Table: A table is a structure in a database that stores data in rows and columns, similar to an Excel spreadsheet. Each row is a record, and each column represents a field or attribute.

2. List five key features of SQL Server.
Data Storage and Management: SQL Server allows you to store and manage data efficiently in a structured format.

Security: It provides strong security features like encryption, user roles, and authentication.

High Availability: Features like Always On and failover clustering help keep your databases available even during failures.

Performance Tuning: It includes tools for indexing, query optimization, and performance monitoring.

Integration with Other Tools: SQL Server works well with tools like Power BI, Excel, and other Microsoft products for data analysis and reporting.

3. What are the different authentication modes available when connecting to SQL Server?
Windows Authentication: Uses your Windows username and password to connect. It’s considered more secure since it integrates with the Windows security system.

SQL Server Authentication: You connect using a specific SQL Server username and password. This is useful when users don’t have Windows accounts.

4. Create a new database in SSMS named SchoolDB.
Steps to create a database in SSMS (SQL Server Management Studio):

Open SSMS and connect to your SQL Server instance.

In the Object Explorer, right-click on Databases and choose New Database.

In the dialog box, type SchoolDB as the database name.

Click OK to create the database.

5. Write and execute a query to create a table called Students with columns: StudentID (INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT).
sql
Copy
Edit
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT
);
6. Describe the differences between SQL Server, SSMS, and SQL.
SQL Server: This is the actual database management system (DBMS). It stores and handles your databases.

SSMS (SQL Server Management Studio): This is a tool used to connect to SQL Server. It provides a graphical interface to manage databases, run queries, and more.

SQL (Structured Query Language): SQL is the language used to write commands that interact with databases. For example, you use SQL to create tables, insert data, or run queries.

7. Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.
DQL (Data Query Language): Used to fetch data from the database.

Example: SELECT * FROM Students;

DML (Data Manipulation Language): Used to change data in the database.

Examples:

INSERT INTO Students VALUES (1, 'Alex', 20);

UPDATE Students SET Age = 21 WHERE StudentID = 1;

DELETE FROM Students WHERE StudentID = 1;

DDL (Data Definition Language): Used to define or change the structure of the database.

Examples:

CREATE TABLE Students (...);

ALTER TABLE Students ADD Grade VARCHAR(5);

DROP TABLE Students;

DCL (Data Control Language): Deals with permissions and access control.

Examples:

GRANT SELECT ON Students TO user1;

REVOKE SELECT ON Students FROM user1;

TCL (Transaction Control Language): Used to manage transactions.

Examples:

BEGIN TRANSACTION;

COMMIT;

ROLLBACK;

8. Write a query to insert three records into the Students table.
sql
Copy
Edit
INSERT INTO Students (StudentID, Name, Age)
VALUES
(1, 'Emma', 19),
(2, 'Liam', 20),
(3, 'Sophia', 18);
9. Restore AdventureWorksDW2022.bak file to your server. (write its steps to submit)
Steps to restore the AdventureWorksDW2022.bak file in SSMS:

Download the .bak file from this link:
AdventureWorksDW2022.bak

Copy the file to your SQL Server backup directory (usually something like C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup).

Open SSMS and connect to your server.

Right-click on Databases > choose Restore Database.

In the Source section, choose Device, then click ... and add the .bak file.

Once selected, it should auto-fill the database name (AdventureWorksDW2022).

Click OK to start the restore process.

After it's done, you should see the new database listed in Object Explorer.

