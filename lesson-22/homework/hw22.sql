Here are my answers to the questions: 

Easy questions
  
1) Running total sales per customer
SELECT
  customer_id,
  customer_name,
  sale_id,
  order_date,
  total_amount,
  SUM(total_amount) OVER (
      PARTITION BY customer_id
      ORDER BY order_date, sale_id
      ROWS UNBOUNDED PRECEDING
  ) AS running_total
FROM sales_data
ORDER BY customer_id, order_date, sale_id;

2) Number of orders per product category
SELECT
  product_category,
  COUNT(*) AS order_count
FROM sales_data
GROUP BY product_category
ORDER BY product_category;

3) Maximum order total_amount per product category
SELECT
  product_category,
  MAX(total_amount) AS max_order_amount
FROM sales_data
GROUP BY product_category
ORDER BY product_category;

4) Minimum unit price per product category
SELECT
  product_category,
  MIN(unit_price) AS min_unit_price
FROM sales_data
GROUP BY product_category
ORDER BY product_category;

5) 3-day moving average of daily sales (prev, curr, next day)
WITH d AS (
  SELECT order_date, SUM(total_amount) AS daily_sales
  FROM sales_data
  GROUP BY order_date
)
SELECT
  order_date,
  daily_sales,
  AVG(daily_sales) OVER (
      ORDER BY order_date
      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS moving_avg_3day
FROM d
ORDER BY order_date;

6) Total sales per region
SELECT
  region,
  SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region
ORDER BY region;

7) Rank customers by total purchase amount (ties share rank)
WITH c AS (
  SELECT customer_id, customer_name, SUM(total_amount) AS total_spent
  FROM sales_data
  GROUP BY customer_id, customer_name
)
SELECT
  customer_id,
  customer_name,
  total_spent,
  RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM c
ORDER BY spend_rank, customer_name;

8) Difference vs. previous sale amount per customer
SELECT
  customer_id,
  customer_name,
  sale_id,
  order_date,
  total_amount,
  total_amount
    - LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date, sale_id
      ) AS diff_from_prev
FROM sales_data
ORDER BY customer_id, order_date, sale_id;

9) Top 3 most expensive products in each category (by unit_price)
WITH p AS (
  SELECT product_category, product_name, MAX(unit_price) AS price
  FROM sales_data
  GROUP BY product_category, product_name
),
r AS (
  SELECT p.*,
         DENSE_RANK() OVER (
           PARTITION BY product_category
           ORDER BY price DESC
         ) AS rnk
  FROM p
)
SELECT product_category, product_name, price
FROM r
WHERE rnk <= 3
ORDER BY product_category, rnk, product_name;

10) Cumulative sum of sales per region by order date
WITH dr AS (
  SELECT region, order_date, SUM(total_amount) AS daily_sales
  FROM sales_data
  GROUP BY region, order_date
)
SELECT
  region,
  order_date,
  daily_sales,
  SUM(daily_sales) OVER (
      PARTITION BY region
      ORDER BY order_date
      ROWS UNBOUNDED PRECEDING
  ) AS cumulative_sales
FROM dr
ORDER BY region, order_date;


Medium Questions

  11) Cumulative revenue per product category (sum of previous values)
WITH d AS (
  SELECT product_category, order_date, SUM(total_amount) AS daily_revenue
  FROM sales_data
  GROUP BY product_category, order_date
)
SELECT
  product_category,
  order_date,
  daily_revenue,
  SUM(daily_revenue) OVER (
      PARTITION BY product_category
      ORDER BY order_date
      ROWS UNBOUNDED PRECEDING
  ) AS cumulative_revenue
FROM d
ORDER BY product_category, order_date;

12) 
  
  SELECT
    ID,
    SUM(ID) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumPreValues
FROM numbers
ORDER BY ID;



13) OneColumn: Sum of previous values to current value

(You gave the table and an “expected” column. Two common interpretations:)

A. Standard cumulative (includes current row): yields 10, 30, 60, 100, 200

SELECT
  Value,
  SUM(Value) OVER (
      ORDER BY Value
      ROWS UNBOUNDED PRECEDING
  ) AS [Sum of Previous]
FROM OneColumn
ORDER BY Value;


B. Strictly previous rows only (excludes current row): yields 0, 10, 30, 60, 100
(Use COALESCE(..., 0) for the first row.)

SELECT
  Value,
  COALESCE(
    SUM(Value) OVER (
      ORDER BY Value
      ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ), 0
  ) AS [Sum of Previous]
FROM OneColumn
ORDER BY Value;

14) Customers who bought from more than one product_category
SELECT
  customer_id,
  customer_name,
  COUNT(DISTINCT product_category) AS category_count
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1
ORDER BY category_count DESC, customer_name;

15) Customers with above-average spending within their region
WITH c AS (
  SELECT region, customer_id, customer_name, SUM(total_amount) AS total_in_region
  FROM sales_data
  GROUP BY region, customer_id, customer_name
),
a AS (
  SELECT region, AVG(total_in_region) AS avg_in_region
  FROM c
  GROUP BY region
)
SELECT c.region, c.customer_id, c.customer_name, c.total_in_region, a.avg_in_region
FROM c
JOIN a ON a.region = c.region
WHERE c.total_in_region > a.avg_in_region
ORDER BY c.region, c.total_in_region DESC;

16) Rank customers by total spending within each region (ties share rank)
WITH c AS (
  SELECT region, customer_id, customer_name, SUM(total_amount) AS total_in_region
  FROM sales_data
  GROUP BY region, customer_id, customer_name
)
SELECT
  region,
  customer_id,
  customer_name,
  total_in_region,
  RANK() OVER (
    PARTITION BY region
    ORDER BY total_in_region DESC
  ) AS region_rank
FROM c
ORDER BY region, region_rank, customer_name;

17) Running total (cumulative_sales) per customer_id by order_date
SELECT
  customer_id,
  customer_name,
  order_date,
  sale_id,
  total_amount,
  SUM(total_amount) OVER (
      PARTITION BY customer_id
      ORDER BY order_date, sale_id
  ) AS cumulative_sales
FROM sales_data
ORDER BY customer_id, order_date, sale_id;

18) Monthly sales growth rate vs. previous month
WITH m AS (
  SELECT
    DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
    SUM(total_amount) AS monthly_sales
  FROM sales_data
  GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
),
g AS (
  SELECT
    month_start,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY month_start) AS prev_month_sales
  FROM m
)
SELECT
  month_start,
  monthly_sales,
  prev_month_sales,
  CAST(
    CASE
      WHEN prev_month_sales IS NULL OR prev_month_sales = 0 THEN NULL
      ELSE (monthly_sales - prev_month_sales) * 100.0 / prev_month_sales
    END AS DECIMAL(10,2)
  ) AS growth_rate_pct
FROM g
ORDER BY month_start;

19) Orders where total_amount > last order’s total_amount (per customer)
WITH s AS (
  SELECT
    *,
    LAG(total_amount) OVER (
      PARTITION BY customer_id
      ORDER BY order_date, sale_id
    ) AS prev_total_amount
  FROM sales_data
)
SELECT
  customer_id,
  customer_name,
  sale_id,
  order_date,
  total_amount,
  prev_total_amount
FROM s
WHERE prev_total_amount IS NOT NULL
  AND total_amount > prev_total_amount
ORDER BY customer_id, order_date, sale_id;

Hard questions 
20) Products priced above average

WITH ProductWithAvg AS (
    SELECT 
        Product_Name,
        Product_Category,
        Unit_Price,
        AVG(Unit_Price) OVER () AS AvgPrice
    FROM sales_data
)
SELECT 
    Product_Name,
    Product_Category,
    Unit_Price
FROM ProductWithAvg
WHERE Unit_Price > AvgPrice
ORDER BY Unit_Price DESC;


21) MyData puzzle — put group total (Val1+Val2) on the first row only (single SELECT)
SELECT 
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM mydata
ORDER BY Grp, Id;

22) TheSumPuzzle — sum Cost normally; Quantity should sum distinct values
SELECT
    ID,
    SUM(Cost) AS Cost,
    CASE 
        WHEN MIN(Quantity) = MAX(Quantity) THEN MIN(Quantity)
        ELSE SUM(Quantity)
    END AS Quantity
FROM TheSumPuzzle
GROUP BY ID
ORDER BY ID;




23) Seats — find missing ranges (gap start/end)
WITH Numbered AS (
    SELECT 
        SeatNumber,
        LAG(SeatNumber) OVER (ORDER BY SeatNumber) AS PrevSeat
    FROM Seats
),
Gaps AS (
    SELECT 
        PrevSeat + 1 AS GapStart,
        SeatNumber - 1 AS GapEnd
    FROM Numbered
    WHERE PrevSeat IS NOT NULL
      AND SeatNumber - PrevSeat > 1
)
SELECT 1 AS GapStart, MIN(SeatNumber)-1 AS GapEnd
FROM Seats
UNION ALL
SELECT GapStart, GapEnd FROM Gaps
UNION ALL
SELECT MAX(SeatNumber)+1, 51  -- replace 51 with the max seat number of your range
FROM Seats
ORDER BY GapStart;
