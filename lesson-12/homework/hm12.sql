Here are my answers: 
Task 1: Combine Two Tables (LEFT JOIN)

SELECT 
    p.firstName, 
    p.lastName, 
    a.city, 
    a.state
FROM 
    Person p
LEFT JOIN 
    Address a ON p.personId = a.personId;

Task 2: Employees Earning More Than Their Managers (Self Join)

SELECT 
    e.name AS Employee
FROM 
    Employee e
JOIN 
    Employee m ON e.managerId = m.id
WHERE 
    e.salary > m.salary;

Task 3: Duplicate Emails

SELECT 
    email
FROM 
    Person
GROUP BY 
    email
HAVING 
    COUNT(*) > 1;

Task 4: Delete Duplicate Emails (Keep lowest ID)

DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);

Task 5: Parents Who Only Have Girls
sql
Copy
Edit
SELECT DISTINCT g.ParentName
FROM girls g
WHERE g.ParentName NOT IN (
    SELECT DISTINCT ParentName FROM boys
);

Task 6: Total over 50 and Least (Sales.Orders in TSQL2012 DB)

SELECT 
    o.custid,
    SUM(od.unitprice * od.qty * (1 - od.discount)) AS TotalSalesOver50,
    MIN(o.freight) AS LeastFreight
FROM 
    TSQL2012.Sales.Orders o
JOIN 
    TSQL2012.Sales.OrderDetails od ON o.orderid = od.orderid
WHERE 
    o.freight > 50
GROUP BY 
    o.custid;

Task 7: Carts (Full Outer Join Simulation)

SELECT 
    c1.Item AS [Item Cart 1],
    c2.Item AS [Item Cart 2]
FROM 
    Cart1 c1
FULL OUTER JOIN 
    Cart2 c2 ON c1.Item = c2.Item;

Task 8: Customers Who Never Order

SELECT 
    c.name AS Customers
FROM 
    Customers c
LEFT JOIN 
    Orders o ON c.id = o.customerId
WHERE 
    o.customerId IS NULL;

Task 9: Students and Examinations (All Combinations + Counts)

SELECT 
    s.student_id,
    s.student_name,
    subj.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM 
    Students s
CROSS JOIN 
    Subjects subj
LEFT JOIN 
    Examinations e ON s.student_id = e.student_id AND subj.subject_name = e.subject_name
GROUP BY 
    s.student_id, s.student_name, subj.subject_name
ORDER BY 
    s.student_id, subj.subject_name;
