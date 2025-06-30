Here are my answers to the questions: 

1. Top 5 employees

SELECT TOP 5 *
FROM Employees;
Result (first 5 rows as inserted by EmployeeID):

EmployeeID	FirstName	LastName	DepartmentName	Salary	HireDate	Age	Email	Country
1	John	Doe	IT	55000.00	2020-01-01	30	johndoe@example.com	USA
2	Jane	Smith	HR	65000.00	2019-03-15	28	janesmith@example.com	USA
3	NULL	Johnson	Finance	45000.00	2021-05-10	25	NULL	Canada
4	James	Brown	Marketing	60000.00	2018-07-22	35	jamesbrown@example.com	UK
5	Patricia	NULL	HR	70000.00	2017-08-30	40	NULL	USA

  
2. Unique product categories

SELECT DISTINCT Category
FROM Products;
Result:

Category
Accessories
Clothing
Electronics
Furniture
Stationery
Tools
  
3. Products with Price > 100

SELECT *
FROM Products
WHERE Price > 100;
Result (Price > 100):
ProductID	ProductName	Price	Category	StockQuantity
1	Laptop	1200.00	Electronics	30
2	Smartphone	800.00	Electronics	50
3	Tablet	400.00	Electronics	40
4	Monitor	250.00	Electronics	60
7	Chair	150.00	Furniture	80
8	Desk	200.00	Furniture	75
11	Printer	180.00	Electronics	25
12	Camera	500.00	Electronics	40
27	Couch	450.00	Furniture	15
28	Fridge	600.00	Electronics	20
29	Stove	500.00	Electronics	15
30	Microwave	120.00	Electronics	25
31	Air Conditioner	350.00	Electronics	10
32	Washing Machine	450.00	Electronics	15
33	Dryer	400.00	Electronics	10
40	Dishwasher	500.00	Electronics	20

4. Customers with names starting ‘A’

SELECT *
FROM Customers
WHERE FirstName LIKE 'A%';
Result:

CustomerID	FirstName	LastName	Email	Phone	Address	City	State	PostalCode	Country
3	Alice	Johnson	alicej@outlook.com	555-3456	789 Pine St	Toronto	ON	M4B1B3	Canada
29	Anna	Roberts	annar@hotmail.com	555-9012	1717 Willow Dr	Sydney	NSW	2000	Australia
  
5. Products ordered by Price ASC

SELECT *
FROM Products
ORDER BY Price ASC;
Result (first 5 by ascending price):

 ProductID	ProductName	Price	Category	StockQuantity
9	Pen	5.00	Stationery	300
25	Cup	5.00	Accessories	500
19	Socks	10.00	Clothing	200
10	Notebook	10.00	Stationery	500
23	Book	15.00	Stationery	250
18	Hat	20.00	Accessories	50
20	T-Shirt	25.00	Clothing	150
26	Bag	25.00	Accessories	300
13	Flashlight	25.00	Tools	200
14	Shirt	30.00	Clothing	150
6	Mouse	30.00	Accessories	120
34	Hair Dryer	30.00	Accessories	100
37	Blender	35.00	Electronics	40
39	Toaster	40.00	Electronics	70
35	Iron	40.00	Electronics	50
15	Jeans	45.00	Clothing	120
5	Keyboard	50.00	Accessories	100
36	Coffee Maker	50.00	Electronics	60
38	Juicer	55.00	Electronics	30
21	Lamp	60.00	Furniture	40
17	Shoes	60.00	Clothing	100
16	Jacket	80.00	Clothing	70
24	Rug	90.00	Furniture	60
22	Coffee Table	100.00	Furniture	35
30	Microwave	120.00	Electronics	25
7	Chair	150.00	Furniture	80
11	Printer	180.00	Electronics	25
8	Desk	200.00	Furniture	75
4	Monitor	250.00	Electronics	60
31	Air Conditioner	350.00	Electronics	10
3	Tablet	400.00	Electronics	40
33	Dryer	400.00	Electronics	10
32	Washing Machine	450.00	Electronics	15
27	Couch	450.00	Furniture	15
29	Stove	500.00	Electronics	15
12	Camera	500.00	Electronics	40
40	Dishwasher	500.00	Electronics	20
28	Fridge	600.00	Electronics	20
2	Smartphone	800.00	Electronics	50
1	Laptop	1200.00	Electronics	30
  
6. Employees with salary ≥ 60000 in HR

SELECT *
FROM Employees
WHERE Salary >= 60000
  AND DepartmentName = 'HR';
Result:


EmployeeID | FirstName  | Dept   | Salary
-----------+------------+--------+--------
2          | Jane       | HR     | 65000
5          | Patricia   | HR     | 70000
9          | Elizabeth  | HR     | 60000
13         | Karen      | HR     | 59000  ← excluded (<60000)
29         | Lisa       | HR     | 60000
37         | Catherine  | HR     | 60000

7. ISNULL to fill missing emails

SELECT EmployeeID, FirstName, LastName,
       ISNULL(Email, 'noemail@example.com') AS Email
FROM Employees;
Result (showing NULL replacements):


1	John	Doe	johndoe@example.com
2	Jane	Smith	janesmith@example.com
3	NULL	Johnson	noemail@example.com
4	James	Brown	jamesbrown@example.com
5	Patricia	NULL	noemail@example.com
6	Michael	Miller	michaelm@example.com
7	Linda	NULL	noemail@example.com
8	David	Moore	davidm@example.com
9	Elizabeth	Taylor	elizabetht@example.com
10	William	NULL	noemail@example.com
11	NULL	Thomas	noemail@example.com
12	Joseph	Jackson	josephj@example.com
13	Karen	White	karenw@gmail.com
14	Steven	NULL	noemail@example.com
15	Nancy	Clark	nancyc@example.com
16	George	Lewis	georgel@example.com
17	Betty	NULL	noemail@example.com
18	Samuel	Walker	samuelw@example.com
19	Helen	Hall	helenh@example.com
20	NULL	Allen	noemail@example.com
21	Betty	Young	bettyy@gmail.com
22	Frank	NULL	frankk@example.com
23	Deborah	Scott	noemail@example.com
24	Matthew	Green	matthewg@example.com
25	NULL	Adams	noemail@example.com
26	Paul	Nelson	pauln@example.com
27	Margaret	NULL	margaretc@example.com
28	Anthony	Mitchell	noemail@example.com
29	Lisa	Perez	lisap@example.com
30	NULL	Roberts	noemail@example.com
31	Jessica	Gonzalez	jessicag@gamil.com
32	Brian	NULL	noemail@example.com
33	Dorothy	Evans	dorothye@example.com
34	Matthew	Carter	matthewc@example.com
35	NULL	Martinez	noemail@example.com
36	Daniel	Perez	danielp@example.com
37	Catherine	Roberts	catheriner@gmail.com
38	Ronald	NULL	noemail@example.com
39	Angela	Jenkins	angelaj@example.com
40	Gary	Wright	noemail@example.com

  
8. Products with Price BETWEEN 50 and 100

SELECT *
FROM Products
WHERE Price BETWEEN 50 AND 100;
Result:

5	Keyboard	50.00	Accessories	100
16	Jacket	80.00	Clothing	70
17	Shoes	60.00	Clothing	100
21	Lamp	60.00	Furniture	40
22	Coffee Table	100.00	Furniture	35
24	Rug	90.00	Furniture	60
36	Coffee Maker	50.00	Electronics	60
38	Juicer	55.00	Electronics	30
  
9. Distinct Category + ProductName

SELECT DISTINCT Category, ProductName
FROM Products;
Result:
Shows unique combinations; duplicates won't repeat.
Accessories	Bag
Accessories	Cup
Accessories	Hair Dryer
Accessories	Hat
Accessories	Keyboard
Accessories	Mouse
Clothing	Jacket
Clothing	Jeans
Clothing	Shirt
Clothing	Shoes
Clothing	Socks
Clothing	T-Shirt
Electronics	Air Conditioner
Electronics	Blender
Electronics	Camera
Electronics	Coffee Maker
Electronics	Dishwasher
Electronics	Dryer
Electronics	Fridge
Electronics	Iron
Electronics	Juicer
Electronics	Laptop
Electronics	Microwave
Electronics	Monitor
Electronics	Printer
Electronics	Smartphone
Electronics	Stove
Electronics	Tablet
Electronics	Toaster
Electronics	Washing Machine
Furniture	Chair
Furniture	Coffee Table
Furniture	Couch
Furniture	Desk
Furniture	Lamp
Furniture	Rug
Stationery	Book
Stationery	Notebook
Stationery	Pen
Tools	Flashlight
  

10. Distinct C/P + order by ProductName DESC

SELECT DISTINCT Category, ProductName
FROM Products
ORDER BY ProductName DESC;
Result (top rows):


Electronics	Washing Machine
Electronics	Toaster
Electronics	Tablet
Clothing	T-Shirt
Electronics	Stove
Clothing	Socks
Electronics	Smartphone
Clothing	Shoes
Clothing	Shirt
Furniture	Rug
Electronics	Printer
Stationery	Pen
Stationery	Notebook
Accessories	Mouse
Electronics	Monitor
Electronics	Microwave
Electronics	Laptop
Furniture	Lamp
Accessories	Keyboard
Electronics	Juicer
Clothing	Jeans
Clothing	Jacket
Electronics	Iron
Accessories	Hat
Accessories	Hair Dryer
Electronics	Fridge
Tools	Flashlight
Electronics	Dryer
Electronics	Dishwasher
Furniture	Desk
Accessories	Cup
Furniture	Couch
Furniture	Coffee Table
Electronics	Coffee Maker
Furniture	Chair
Electronics	Camera
Stationery	Book
Electronics	Blender
Accessories	Bag
Electronics	Air Conditioner

Medium-Level Tasks
11. Top 10 products by highest price

SELECT TOP 10 *
FROM Products
ORDER BY Price DESC;
Result:

ProductID	ProductName	Price	Category	StockQuantity
1	Laptop	1200.00	Electronics	30
2	Smartphone	800.00	Electronics	50
28	Fridge	600.00	Electronics	20
12	Camera	500.00	Electronics	40
29	Stove	500.00	Electronics	15
40	Dishwasher	500.00	Electronics	20
27	Couch	450.00	Furniture	15
32	Washing Machine	450.00	Electronics	15
3	Tablet	400.00	Electronics	40
33	Dryer	400.00	Electronics	10
  
12. COALESCE FirstName/LastName

SELECT EmployeeID, COALESCE(FirstName, LastName) AS Name
FROM Employees;
Result (sample):

EmployeeID	Name
1	John
2	Jane
3	Johnson
4	James
5	Patricia
6	Michael
7	Linda
8	David
9	Elizabeth
10	William
11	Thomas
12	Joseph
13	Karen
14	Steven
15	Nancy
16	George
17	Betty
18	Samuel
19	Helen
20	Allen
21	Betty
22	Frank
23	Deborah
24	Matthew
25	Adams
26	Paul
27	Margaret
28	Anthony
29	Lisa
30	Roberts
31	Jessica
32	Brian
33	Dorothy
34	Matthew
35	Martinez
36	Daniel
37	Catherine
38	Ronald
39	Angela
40	Gary
  
13. Distinct Category + Price

SELECT DISTINCT Category, Price
FROM Products;
Result:
Each unique price per category only once.
Category	Price
Accessories	5.00
Accessories	20.00
Accessories	25.00
Accessories	30.00
Accessories	50.00
Clothing	10.00
Clothing	25.00
Clothing	30.00
Clothing	45.00
Clothing	60.00
Clothing	80.00
Electronics	35.00
Electronics	40.00
Electronics	50.00
Electronics	55.00
Electronics	120.00
Electronics	180.00
Electronics	250.00
Electronics	350.00
Electronics	400.00
Electronics	450.00
Electronics	500.00
Electronics	600.00
Electronics	800.00
Electronics	1200.00
Furniture	60.00
Furniture	90.00
Furniture	100.00
Furniture	150.00
Furniture	200.00
Furniture	450.00
Stationery	5.00
Stationery	10.00
Stationery	15.00
Tools	25.00
  
14. Employees age 30–40 or in Marketing

SELECT *
FROM Employees
WHERE (Age BETWEEN 30 AND 40)
   OR DepartmentName = 'Marketing';
Result:

EmployeeID	FirstName	LastName	DepartmentName	Salary	HireDate	Age	Email	Country
1	John	Doe	IT	55000.00	2020-01-01	30	johndoe@example.com	USA
4	James	Brown	Marketing	60000.00	2018-07-22	35	jamesbrown@example.com	UK
5	Patricia	NULL	HR	70000.00	2017-08-30	40	NULL	USA
8	David	Moore	Marketing	85000.00	2021-09-01	29	davidm@example.com	UK
9	Elizabeth	Taylor	HR	60000.00	2019-05-18	31	elizabetht@example.com	USA
11	NULL	Thomas	Finance	47000.00	2017-01-25	38	NULL	Canada
12	Joseph	Jackson	Marketing	78000.00	2016-09-30	44	josephj@example.com	UK
13	Karen	White	HR	59000.00	2018-06-10	33	karenw@gmail.com	USA
16	George	Lewis	Marketing	80000.00	2019-11-10	36	georgel@example.com	UK
19	Helen	Hall	Finance	49000.00	2018-10-16	34	helenh@example.com	Canada
20	NULL	Allen	Marketing	90000.00	2015-08-11	50	NULL	UK
24	Matthew	Green	Marketing	76000.00	2021-01-15	30	matthewg@example.com	UK
26	Paul	Nelson	IT	71000.00	2018-12-03	37	pauln@example.com	Germany
28	Anthony	Mitchell	Marketing	82000.00	2021-04-10	29	NULL	UK
30	NULL	Roberts	IT	69000.00	2019-09-24	32	NULL	Germany
31	Jessica	Gonzalez	Finance	47000.00	2017-12-13	38	jessicag@gamil.com	Canada
32	Brian	NULL	Marketing	85000.00	2018-11-05	35	NULL	UK
33	Dorothy	Evans	HR	59000.00	2019-06-11	31	dorothye@example.com	USA
36	Daniel	Perez	Marketing	83000.00	2021-07-01	30	danielp@example.com	UK
38	Ronald	NULL	IT	68000.00	2017-02-04	39	NULL	Germany
39	Angela	Jenkins	Finance	52000.00	2018-04-23	34	angelaj@example.com	Canada
40	Gary	Wright	Marketing	87000.00	2021-01-10	29	NULL	UK

15. Rows 11–20 ordered by Salary DESC

SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
Result:
Employees ranked 11–20 highest paid.
EmployeeID	FirstName	LastName	DepartmentName	Salary	HireDate	Age	Email	Country
18	Samuel	Walker	IT	72000.00	2021-03-22	23	samuelw@example.com	Germany
14	Steven	NULL	IT	71000.00	2021-07-15	24	NULL	Germany
26	Paul	Nelson	IT	71000.00	2018-12-03	37	pauln@example.com	Germany
5	Patricia	NULL	HR	70000.00	2017-08-30	40	NULL	USA
34	Matthew	Carter	IT	70000.00	2020-01-29	29	matthewc@example.com	Germany
30	NULL	Roberts	IT	69000.00	2019-09-24	32	NULL	Germany
38	Ronald	NULL	IT	68000.00	2017-02-04	39	NULL	Germany
22	Frank	NULL	IT	67000.00	2021-02-02	26	frankk@example.com	Germany
2	Jane	Smith	HR	65000.00	2019-03-15	28	janesmith@example.com	USA
10	William	NULL	IT	64000.00	2020-04-10	26	NULL	Germany

16. Products Price ≤1000 & Stock >50, sorted by Stock

SELECT *
FROM Products
WHERE Price <= 1000
  AND StockQuantity > 50
ORDER BY StockQuantity ASC;
Result:

ProductID	ProductName	Price	Category	StockQuantity
4	Monitor	250.00	Electronics	60
24	Rug	90.00	Furniture	60
36	Coffee Maker	50.00	Electronics	60
39	Toaster	40.00	Electronics	70
16	Jacket	80.00	Clothing	70
8	Desk	200.00	Furniture	75
7	Chair	150.00	Furniture	80
5	Keyboard	50.00	Accessories	100
17	Shoes	60.00	Clothing	100
34	Hair Dryer	30.00	Accessories	100
6	Mouse	30.00	Accessories	120
15	Jeans	45.00	Clothing	120
14	Shirt	30.00	Clothing	150
20	T-Shirt	25.00	Clothing	150
19	Socks	10.00	Clothing	200
13	Flashlight	25.00	Tools	200
23	Book	15.00	Stationery	250
26	Bag	25.00	Accessories	300
9	Pen	5.00	Stationery	300
10	Notebook	10.00	Stationery	500
25	Cup	5.00	Accessories	500
  
17. ProductName contains 'e'

SELECT *
FROM Products
WHERE ProductName LIKE '%e%';
Result:
Key ones: "Pen", "Desk", "Notebook", "T-Shirt", etc.
ProductID	ProductName	Price	Category	StockQuantity
2	Smartphone	800.00	Electronics	50
3	Tablet	400.00	Electronics	40
5	Keyboard	50.00	Accessories	100
6	Mouse	30.00	Accessories	120
8	Desk	200.00	Furniture	75
9	Pen	5.00	Stationery	300
10	Notebook	10.00	Stationery	500
11	Printer	180.00	Electronics	25
12	Camera	500.00	Electronics	40
15	Jeans	45.00	Clothing	120
16	Jacket	80.00	Clothing	70
17	Shoes	60.00	Clothing	100
22	Coffee Table	100.00	Furniture	35
28	Fridge	600.00	Electronics	20
29	Stove	500.00	Electronics	15
30	Microwave	120.00	Electronics	25
31	Air Conditioner	350.00	Electronics	10
32	Washing Machine	450.00	Electronics	15
33	Dryer	400.00	Electronics	10
34	Hair Dryer	30.00	Accessories	100
36	Coffee Maker	50.00	Electronics	60
37	Blender	35.00	Electronics	40
38	Juicer	55.00	Electronics	30
39	Toaster	40.00	Electronics	70
40	Dishwasher	500.00	Electronics	20
  
18. Employees in HR, IT, Finance

SELECT *
FROM Employees
WHERE DepartmentName IN ('HR','IT','Finance');
Result:
All employees in those departments.
EmployeeID	FirstName	LastName	DepartmentName	Salary	HireDate	Age	Email	Country
1	John	Doe	IT	55000.00	2020-01-01	30	johndoe@example.com	USA
2	Jane	Smith	HR	65000.00	2019-03-15	28	janesmith@example.com	USA
3	NULL	Johnson	Finance	45000.00	2021-05-10	25	NULL	Canada
5	Patricia	NULL	HR	70000.00	2017-08-30	40	NULL	USA
6	Michael	Miller	IT	75000.00	2020-12-12	27	michaelm@example.com	Germany
7	Linda	NULL	Finance	48000.00	2016-11-02	42	NULL	Canada
9	Elizabeth	Taylor	HR	60000.00	2019-05-18	31	elizabetht@example.com	USA
10	William	NULL	IT	64000.00	2020-04-10	26	NULL	Germany
11	NULL	Thomas	Finance	47000.00	2017-01-25	38	NULL	Canada
13	Karen	White	HR	59000.00	2018-06-10	33	karenw@gmail.com	USA
14	Steven	NULL	IT	71000.00	2021-07-15	24	NULL	Germany
15	Nancy	Clark	Finance	45000.00	2020-02-20	27	nancyc@example.com	Canada
17	Betty	NULL	HR	55000.00	2017-04-05	41	NULL	USA
18	Samuel	Walker	IT	72000.00	2021-03-22	23	samuelw@example.com	Germany
19	Helen	Hall	Finance	49000.00	2018-10-16	34	helenh@example.com	Canada
21	Betty	Young	HR	53000.00	2020-05-17	28	bettyy@gmail.com	USA
22	Frank	NULL	IT	67000.00	2021-02-02	26	frankk@example.com	Germany
23	Deborah	Scott	Finance	47000.00	2019-07-09	29	NULL	Canada
25	NULL	Adams	HR	54000.00	2020-06-21	27	NULL	USA
26	Paul	Nelson	IT	71000.00	2018-12-03	37	pauln@example.com	Germany
27	Margaret	NULL	Finance	46000.00	2020-08-19	25	margaretc@example.com	Canada
29	Lisa	Perez	HR	60000.00	2021-03-05	24	lisap@example.com	USA
30	NULL	Roberts	IT	69000.00	2019-09-24	32	NULL	Germany
31	Jessica	Gonzalez	Finance	47000.00	2017-12-13	38	jessicag@gamil.com	Canada
33	Dorothy	Evans	HR	59000.00	2019-06-11	31	dorothye@example.com	USA
34	Matthew	Carter	IT	70000.00	2020-01-29	29	matthewc@example.com	Germany
35	NULL	Martinez	Finance	51000.00	2021-06-06	22	NULL	Canada
37	Catherine	Roberts	HR	60000.00	2020-09-19	27	catheriner@gmail.com	USA
38	Ronald	NULL	IT	68000.00	2017-02-04	39	NULL	Germany
39	Angela	Jenkins	Finance	52000.00	2018-04-23	34	angelaj@example.com	Canada

  19. Customers ordered by City ASC, PostalCode DESC

SELECT *
FROM Customers
ORDER BY City ASC, PostalCode DESC;
Result :

CustomerID	FirstName	LastName	Email	Phone	Address	City	State	PostalCode	Country
10	Helen	Gonzalez	heleng@yahoo.com	555-0123	707 Fir St	Berlin	BE	10117	Germany
35	Grace	Lee	gracel@live.com	555-5678	2323 Birch St	Berlin	BE	10117	Germany
9	Grace	Lopez	gracel@gmail.com	555-9012	606 Aspen St	Birmingham	England	B1 1AA	UK
20	Rachel	Harris	rachelh@hotmail.com	555-0123	888 Pine Blvd	Busan	BU	48058	South Korea
27	Yvonne	Carter	yvonnec@yahoo.com	555-7890	1515 Maple Dr	Chicago	IL	60601	USA
23	Ursula	Scott	ursulas@outlook.com	555-3456	1111 Willow Blvd	Guadalajara	JAL	44100	Mexico
12	Jack	Wilson	jackw@live.com	555-2345	909 Oak Ave	Hamburg	HH	20095	Germany
28	Zane	Mitchell	zanem@outlook.com	555-8901	1616 Redwood Dr	Houston	TX	77001	USA
21	Sam	Clark	samc@gmail.com	555-1234	999 Cedar Blvd	Incheon	IC	22382	South Korea
18	Paul	White	paulw@yahoo.com	555-8901	666 Maple Blvd	Kyoto	KY	600-8001	Japan
38	Jasmine	Walker	jasminew@outlook.com	555-8901	2626 Redwood St	Lisbon	LI	1100-148	Portugal
33	Ella	Collins	ellac@outlook.com	555-3456	2121 Redwood Dr	London	England	SW1A 1AA	UK
7	Emily	Garcia	emilyg@yahoo.com	555-7890	404 Redwood St	London	England	SW1A 1AA	UK
2	Jane	Smith	janesmith@yahoo.com	555-2345	456 Oak St	Los Angeles	CA	90001	USA
26	Xander	Nelson	xandern@gmail.com	555-6789	1414 Cedar Blvd	Los Angeles	CA	90001	USA
14	Liam	Thomas	liamt@yahoo.com	555-4567	222 Cedar Ave	Lyon	Auvergne-Rh?ne-Alpes	69001	France
8	Frank	Hernandez	frankh@outlook.com	555-8901	505 Willow St	Manchester	England	M1 1AE	UK
34	Finn	Morris	finnm@hotmail.com	555-4567	2222 Willow St	Manchester	England	M1 1AE	UK
15	Megan	Taylor	megant@outlook.com	555-5678	333 Redwood Ave	Marseille	Provence-Alpes-C?te Azur	13001	France
6	David	Martinez	davidm@live.com	555-6789	303 Cedar St	Melbourne	VIC	3000	Australia
30	Ben	King	benk@live.com	555-0123	1818 Birch Dr	Melbourne	VIC	3000	Australia
22	Tina	Allen	tinaallen@yahoo.com	555-2345	1010 Redwood Blvd	Mexico City	CMX	01000	Mexico
24	Victor	Adams	victora@hotmail.com	555-4567	1212 Birch Blvd	Monterrey	NLE	64000	Mexico
36	Holly	Martinez	hollym@gmail.com	555-6789	2424 Oak St	Munich	BY	80331	Germany
11	Irene	Perez	irenep@hotmail.com	555-1234	808 Maple Ave	Munich	BY	80331	Germany
1	John	Doe	johndoe@gmail.com	555-1234	123 Elm St	New York	NY	10001	USA
25	Walter	Baker	walterb@live.com	555-5678	1313 Oak Blvd	New York	NY	10001	USA
17	Olivia	Jackson	oliviaj@gmail.com	555-7890	555 Birch Ave	Osaka	OS	530-0001	Japan
13	Kim	Anderson	kima@gmail.com	555-3456	111 Pine Ave	Paris	?le-de-France	75001	France
39	Kyle	Young	kyley@hotmail.com	555-9012	2727 Willow St	Pittsburgh	PA	15201	USA
40	Liam	Harris	liamh@live.com	555-0123	2828 Birch St	Richmond	VA	23220	USA
19	Quincy	Lee	quincyl@outlook.com	555-9012	777 Oak Blvd	Seoul	SO	04547	South Korea
5	Charlie	Davis	charliedavis@gmail.com	555-5678	202 Birch St	Sydney	NSW	2000	Australia
29	Anna	Roberts	annar@hotmail.com	555-9012	1717 Willow Dr	Sydney	NSW	2000	Australia
16	Nathan	Moore	nathanm@hotmail.com	555-6789	444 Willow Ave	Tokyo	TK	100-0001	Japan
3	Alice	Johnson	alicej@outlook.com	555-3456	789 Pine St	Toronto	ON	M4B1B3	Canada
31	Chloe	Green	chloeg@gmail.com	555-1234	1919 Oak Dr	Toronto	ON	M4B1B3	Canada
32	Daniel	Evans	daniele@yahoo.com	555-2345	2020 Cedar Dr	Vancouver	BC	V5K0A1	Canada
4	Bob	Brown	bobbrown@hotmail.com	555-4567	101 Maple St	Vancouver	BC	V5K0A1	Canada
37	Ian	Robinson	ianr@yahoo.com	555-7890	2525 Cedar St	Warsaw	WA	00-001	Poland
Hard-Level Tasks

20. Top 5 products by sales

SELECT TOP 5 p.ProductName, SUM(s.SaleAmount) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSales DESC;
Result:

ProductName	TotalSales
Notebook	2400.00
Pen	2200.00
Desk	2000.00
Chair	1800.00
Mouse	1600.00

21. FullName column

SELECT EmployeeID,
       ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') AS FullName
FROM Employees;
Result:

EmployeeID	FullName
1	John Doe
2	Jane Smith
3	 Johnson
4	James Brown
5	Patricia 
6	Michael Miller
7	Linda 
8	David Moore
9	Elizabeth Taylor
10	William 
11	 Thomas
12	Joseph Jackson
13	Karen White
14	Steven 
15	Nancy Clark
16	George Lewis
17	Betty 
18	Samuel Walker
19	Helen Hall
20	 Allen
21	Betty Young
22	Frank 
23	Deborah Scott
24	Matthew Green
25	 Adams
26	Paul Nelson
27	Margaret 
28	Anthony Mitchell
29	Lisa Perez
30	 Roberts
31	Jessica Gonzalez
32	Brian 
33	Dorothy Evans
34	Matthew Carter
35	 Martinez
36	Daniel Perez
37	Catherine Roberts
38	Ronald 
39	Angela Jenkins
40	Gary Wright
  
22. Distinct C/P/N where Price >50

SELECT DISTINCT Category, ProductName, Price
FROM Products
WHERE Price > 50;
Result:
Filtered rows with unique triple combinations.
Category	ProductName	Price
Clothing	Jacket	80.00
Clothing	Shoes	60.00
Electronics	Air Conditioner	350.00
Electronics	Camera	500.00
Electronics	Dishwasher	500.00
Electronics	Dryer	400.00
Electronics	Fridge	600.00
Electronics	Juicer	55.00
Electronics	Laptop	1200.00
Electronics	Microwave	120.00
Electronics	Monitor	250.00
Electronics	Printer	180.00
Electronics	Smartphone	800.00
Electronics	Stove	500.00
Electronics	Tablet	400.00
Electronics	Washing Machine	450.00
Furniture	Chair	150.00
Furniture	Coffee Table	100.00
Furniture	Couch	450.00
Furniture	Desk	200.00
Furniture	Lamp	60.00
Furniture	Rug	90.00
  

23. Products priced <10% of average price

SELECT *
FROM Products
WHERE Price < (SELECT AVG(Price)*0.1 FROM Products);
Result:
  
ProductID	ProductName	Price	Category	StockQuantity
9	Pen	5.00	Stationery	300
10	Notebook	10.00	Stationery	500
19	Socks	10.00	Clothing	200
23	Book	15.00	Stationery	250
25	Cup	5.00	Accessories	500

24. Employees Age <30 AND dept HR or IT

SELECT *
FROM Employees
WHERE Age < 30
  AND DepartmentName IN ('HR','IT');
Result:

EmployeeID	FirstName	LastName	DepartmentName	Salary	HireDate	Age	Email	Country
2	Jane	Smith	HR	65000.00	2019-03-15	28	janesmith@example.com	USA
6	Michael	Miller	IT	75000.00	2020-12-12	27	michaelm@example.com	Germany
10	William	NULL	IT	64000.00	2020-04-10	26	NULL	Germany
14	Steven	NULL	IT	71000.00	2021-07-15	24	NULL	Germany
18	Samuel	Walker	IT	72000.00	2021-03-22	23	samuelw@example.com	Germany
21	Betty	Young	HR	53000.00	2020-05-17	28	bettyy@gmail.com	USA
22	Frank	NULL	IT	67000.00	2021-02-02	26	frankk@example.com	Germany
25	NULL	Adams	HR	54000.00	2020-06-21	27	NULL	USA
29	Lisa	Perez	HR	60000.00	2021-03-05	24	lisap@example.com	USA
34	Matthew	Carter	IT	70000.00	2020-01-29	29	matthewc@example.com	Germany
37	Catherine	Roberts	HR	60000.00	2020-09-19	27	catheriner@gmail.com	USA
  
25. Customers with '@gmail.com'

SELECT *
FROM Customers
WHERE Email LIKE '%@gmail.com';
Result:

CustomerID	FirstName	LastName	Email	Phone	Address	City	State	PostalCode	Country
1	John	Doe	johndoe@gmail.com	555-1234	123 Elm St	New York	NY	10001	USA
5	Charlie	Davis	charliedavis@gmail.com	555-5678	202 Birch St	Sydney	NSW	2000	Australia
9	Grace	Lopez	gracel@gmail.com	555-9012	606 Aspen St	Birmingham	England	B1 1AA	UK
13	Kim	Anderson	kima@gmail.com	555-3456	111 Pine Ave	Paris	?le-de-France	75001	France
17	Olivia	Jackson	oliviaj@gmail.com	555-7890	555 Birch Ave	Osaka	OS	530-0001	Japan
21	Sam	Clark	samc@gmail.com	555-1234	999 Cedar Blvd	Incheon	IC	22382	South Korea
26	Xander	Nelson	xandern@gmail.com	555-6789	1414 Cedar Blvd	Los Angeles	CA	90001	USA
31	Chloe	Green	chloeg@gmail.com	555-1234	1919 Oak Dr	Toronto	ON	M4B1B3	Canada
36	Holly	Martinez	hollym@gmail.com	555-6789	2424 Oak St	Munich	BY	80331	Germany
  
26. Employees earning > all in Sales dept

SELECT *
FROM Employees
WHERE Salary > ALL (
  SELECT Salary FROM Employees WHERE DepartmentName = 'Sales'
);
Result:
EmployeeID	FirstName	LastName	DepartmentName	Salary	HireDate	Age	Email	Country
1	John	Doe	IT	55000.00	2020-01-01	30	johndoe@example.com	USA
2	Jane	Smith	HR	65000.00	2019-03-15	28	janesmith@example.com	USA
3	NULL	Johnson	Finance	45000.00	2021-05-10	25	NULL	Canada
4	James	Brown	Marketing	60000.00	2018-07-22	35	jamesbrown@example.com	UK
5	Patricia	NULL	HR	70000.00	2017-08-30	40	NULL	USA
6	Michael	Miller	IT	75000.00	2020-12-12	27	michaelm@example.com	Germany
7	Linda	NULL	Finance	48000.00	2016-11-02	42	NULL	Canada
8	David	Moore	Marketing	85000.00	2021-09-01	29	davidm@example.com	UK
9	Elizabeth	Taylor	HR	60000.00	2019-05-18	31	elizabetht@example.com	USA
10	William	NULL	IT	64000.00	2020-04-10	26	NULL	Germany
11	NULL	Thomas	Finance	47000.00	2017-01-25	38	NULL	Canada
12	Joseph	Jackson	Marketing	78000.00	2016-09-30	44	josephj@example.com	UK
13	Karen	White	HR	59000.00	2018-06-10	33	karenw@gmail.com	USA
14	Steven	NULL	IT	71000.00	2021-07-15	24	NULL	Germany
15	Nancy	Clark	Finance	45000.00	2020-02-20	27	nancyc@example.com	Canada
16	George	Lewis	Marketing	80000.00	2019-11-10	36	georgel@example.com	UK
17	Betty	NULL	HR	55000.00	2017-04-05	41	NULL	USA
18	Samuel	Walker	IT	72000.00	2021-03-22	23	samuelw@example.com	Germany
19	Helen	Hall	Finance	49000.00	2018-10-16	34	helenh@example.com	Canada
20	NULL	Allen	Marketing	90000.00	2015-08-11	50	NULL	UK
21	Betty	Young	HR	53000.00	2020-05-17	28	bettyy@gmail.com	USA
22	Frank	NULL	IT	67000.00	2021-02-02	26	frankk@example.com	Germany
23	Deborah	Scott	Finance	47000.00	2019-07-09	29	NULL	Canada
24	Matthew	Green	Marketing	76000.00	2021-01-15	30	matthewg@example.com	UK
25	NULL	Adams	HR	54000.00	2020-06-21	27	NULL	USA
26	Paul	Nelson	IT	71000.00	2018-12-03	37	pauln@example.com	Germany
27	Margaret	NULL	Finance	46000.00	2020-08-19	25	margaretc@example.com	Canada
28	Anthony	Mitchell	Marketing	82000.00	2021-04-10	29	NULL	UK
29	Lisa	Perez	HR	60000.00	2021-03-05	24	lisap@example.com	USA
30	NULL	Roberts	IT	69000.00	2019-09-24	32	NULL	Germany
31	Jessica	Gonzalez	Finance	47000.00	2017-12-13	38	jessicag@gamil.com	Canada
32	Brian	NULL	Marketing	85000.00	2018-11-05	35	NULL	UK
33	Dorothy	Evans	HR	59000.00	2019-06-11	31	dorothye@example.com	USA
34	Matthew	Carter	IT	70000.00	2020-01-29	29	matthewc@example.com	Germany
35	NULL	Martinez	Finance	51000.00	2021-06-06	22	NULL	Canada
36	Daniel	Perez	Marketing	83000.00	2021-07-01	30	danielp@example.com	UK
37	Catherine	Roberts	HR	60000.00	2020-09-19	27	catheriner@gmail.com	USA
38	Ronald	NULL	IT	68000.00	2017-02-04	39	NULL	Germany
39	Angela	Jenkins	Finance	52000.00	2018-04-23	34	angelaj@example.com	Canada
40	Gary	Wright	Marketing	87000.00	2021-01-10	29	NULL	UK

27. Orders in last 180 days

SELECT *
FROM Orders
WHERE OrderDate BETWEEN DATEADD(DAY, -180, GETDATE()) AND GETDATE();
Result:
OrderID	CustomerID	ProductID	OrderDate	Quantity	TotalAmount
19	19	20	2025-03-05	2	50.00
24	24	25	2025-06-23	3	15.00
29	29	30	2025-05-28	2	240.00
38	38	39	2025-02-01	1	40.00

