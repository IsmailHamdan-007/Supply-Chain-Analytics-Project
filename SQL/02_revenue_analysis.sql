USE SupplychainDB;

-- 1. Total Revenue
SELECT 
	SUM(Sales) AS Total_Revenue
FROM sales;

-- 2. Monthly Revenue Trend
SELECT
	YEAR(O.Order_Date) AS Years,
	MONTH(O.Order_Date) AS Months,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY YEAR(O.Order_Date),
	MONTH(O.Order_Date)
ORDER BY Years, Months;

-- 3. Revenue by Market
SELECT 
	O.Market,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Market
ORDER BY Revenue;

-- 4. Revenue by Category
SELECT 
	P.Category_Name,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name
ORDER BY Revenue;

-- 5. Revenue by Department
SELECT 
	P.Department_Name,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name
ORDER BY Revenue;

-- 6. Top Revenue Products
WITH ProductRevenue AS
(
    SELECT
        P.Product_Name,
        SUM(S.Sales) AS Revenue,
        ROW_NUMBER() OVER
        (
            ORDER BY SUM(S.Sales) DESC
        ) AS rn
    FROM sales S
    JOIN products P
        ON S.Product_Card_Id = P.Product_Card_Id
    GROUP BY P.Product_Name
)
SELECT *
FROM ProductRevenue
WHERE rn <= 3;

-- 7. Top Revenue Customers
SELECT TOP 3
	C.Customer_Name,
	SUM(S.Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(S.Sales) DESC) AS TOP_Products
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Name;

-- 8. Revenue Contribution by Market
SELECT 
	O.Market,
	SUM(S.Sales) AS Revenue,
	ROUND(SUM(S.Sales) * 100.00 /
		SUM(SUM(S.Sales)) OVER(), 2)
	AS Contribution_pert
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Market
ORDER BY Revenue;

-- 9. Revenue Contribution % by Category
SELECT 
	P.Category_Name,
	SUM(S.Sales) AS Revenue,
	ROUND(SUM(S.Sales) * 100.00 /
		SUM(SUM(S.Sales)) OVER(), 2)
	AS Contribution_Percent
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name;

-- 10. Revenue Contribution % by Department
SELECT 
	P.Department_Name,
	SUM(S.Sales) AS Revenue,
	ROUND(SUM(S.Sales) * 100.00 /
		SUM(SUM(S.Sales)) OVER(), 2)
	AS Contribution_Percent
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name;

-- 11. Average Revenue per Customer
WITH avg_rev_per_cust AS
(
SELECT 
	SUM(S.Sales) AS Revenue,
	COUNT(DISTINCT C.Customer_Id) AS Counts
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Id
)
SELECT 
	AVG(Revenue) AS avg_rev_per_cust
FROM avg_rev_per_cust;

-- 12. Average Revenue per Order
WITH avg_ord AS
(
SELECT 
	O.Order_Id,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Order_Id
)
SELECT 
	AVG(Revenue) AS avg_rev_per_ord
FROM avg_ord;

-- 13.Revenue per Market per Month
SELECT 
	YEAR(O.Order_Date) AS Years,
	MONTH(O.Order_Date) AS Months,
	SUM(S.Sales) AS Revenue,
	O.Market
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY YEAR(O.Order_Date), MONTH(O.Order_Date),
	O.Market
ORDER BY Years, Months;







































