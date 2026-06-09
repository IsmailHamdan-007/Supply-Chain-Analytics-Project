USE SupplychainDB;

--=================================================================================================
----------------------------------- PRODUCT ANALYSIS ----------------------------------------------
--=================================================================================================
-- 1. Total Products
SELECT 
	COUNT(DISTINCT Product_Name) AS Total_Product_Counts
FROM products;

-- 2. Products by Category
SELECT
    Category_Name,
    COUNT(Product_Card_Id) AS Product_Count
FROM products
GROUP BY Category_Name
ORDER BY Product_Count DESC;


-- 3. Products by Department
SELECT 
	Department_Name,
	COUNT(Product_Card_Id) AS Product_Count
FROM products 
GROUP BY Department_Name
ORDER BY Product_Count DESC;


-- 4. Product Performance Summary (Revenue, Profit, Quantity)
SELECT 
	P.Product_Name,
	SUM(S.Order_Item_Quantity) AS Total_Qnty,
	SUM(S.Sales) AS Revenue,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY Product_Name;

-- 5. Top Performing Products (Revenue, Profit, Quantity)
SELECT TOP 3
	P.Product_Name,
	SUM(S.Order_Item_Quantity) AS Total_Qnty,
	SUM(S.Sales) AS Revenue,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY Product_Name
ORDER BY Revenue DESC;


-- 6. Bottom Performing Products (Revenue, Profit)
WITH Least_Perf_Prod AS
(
SELECT 
	P.Product_Name,
	SUM(S.Sales) AS Revenue,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Sales), SUM(S.Profit) ASC)
	AS Rnk
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY Product_Name
)
SELECT *
FROM Least_Perf_Prod
WHERE Rnk <=3;

-- 7. Product Revenue Contribution %
SELECT 
	P.Product_Name,
	SUM(S.Sales) AS Revenue,
	ROUND(SUM(S.Sales) * 100.00 /
		SUM(SUM(S.Sales)) OVER(), 2)
	AS Contribution
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
ORDER BY Revenue DESC;


-- 8. Product Profit Contribution %
SELECT 
	P.Product_Name,
	SUM(S.Profit) AS Profits,
	ROUND(SUM(S.Profit) * 100.00 /
		SUM(SUM(S.Profit)) OVER(), 2)
	AS Contribution
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
ORDER BY Profits DESC;


-- 9. Product Performance Ranking
SELECT 
	P.Product_Name,
	SUM(S.Order_Item_Quantity) AS Total_Qnty,
	SUM(S.Sales) AS Revenue,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Order_Item_Quantity) DESC)
	AS Qnty_Rnk,
	RANK() OVER(
		ORDER BY SUM(S.Sales) DESC)
	AS Revenue_Rnk,
	RANK() OVER(
		ORDER BY SUM(S.Profit) DESC)
	AS Profit_Rnk
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY Product_Name;


-- 10. Category & Department Performance Ranking
SELECT 
	P.Department_Name,
	P.Category_Name,
	SUM(S.Order_Item_Quantity) AS Total_Qnty,
	SUM(S.Sales) AS Revenue,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Order_Item_Quantity) DESC)
	AS Qnty_Rnk,
	RANK() OVER(
		ORDER BY SUM(S.Sales) DESC)
	AS Revenue_Rnk,
	RANK() OVER(
		ORDER BY SUM(S.Profit) DESC)
	AS Profit_Rnk
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name, P.Category_Name;


-- 11. Products with Negative Profit
SELECT 
	P.Product_Name,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
HAVING SUM(S.Profit) < 0;

-- 12. Top Product in Each Category

WITH Category_Rank AS
(
SELECT
    P.Category_Name,
    P.Product_Name,
    SUM(S.Sales) AS Revenue,

    RANK() OVER(
        PARTITION BY P.Category_Name
        ORDER BY SUM(S.Sales) DESC
    ) AS Rnk

FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id

GROUP BY
    P.Category_Name,
    P.Product_Name
)

SELECT *
FROM Category_Rank
WHERE Rnk = 1;