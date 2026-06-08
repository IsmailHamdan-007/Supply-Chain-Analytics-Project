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


-- Revenue by Category

-- Revenue by Department

-- Top Revenue Products

-- Top Revenue Customers

-- Revenue Contribution by Market

































