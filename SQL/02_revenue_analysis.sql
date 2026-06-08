USE SupplychainDB;

-- Total Revenue
SELECT 
	SUM(Sales) AS Total_Revenue
FROM sales;

-- Monthly Revenue Trend
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

-- Revenue by Market
SELECT 
	O.Market,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Market
ORDER BY Revenue;

-- Revenue by Category
SELECT 
	P.Category_Name,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name
ORDER BY Revenue;

-- Revenue by Department
SELECT 
	P.Department_Name,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name
ORDER BY Revenue;

-- Top Revenue Products
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

-- Top Revenue Customers
SELECT TOP 3
	C.Customer_Name,
	SUM(S.Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(S.Sales) DESC) AS TOP_Products
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Name;

-- Revenue Contribution by Market
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


































