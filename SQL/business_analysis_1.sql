USE SupplychainDB;

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM shipping;
SELECT * FROM sales;

-- =====================================================================
----------------------------- REVENUE ANALYSIS ---------------------
-- =====================================================================

-- 1. Total Revenue.
SELECT SUM(Sales) AS Total_Revenue
FROM Sales;

-- 2. Monthly Revenue Trend.
SELECT 
	YEAR(O.Order_Date) AS Years,
	MONTH(O.Order_Date) AS Months,
	SUM(Sales) AS Revenue
FROM sales S
INNER JOIN Orders O
ON S.Order_Id = O.Order_Id
GROUP BY YEAR(O.Order_Date), MONTH(O.Order_Date) 
ORDER BY Years, Months ASC;

-- 3. Top 10 Revenue Generating Products.
SELECT TOP 10
	P.Product_Name,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
ORDER BY Revenue DESC;

-- 4. Top 10 Revenue Generating Customers.
SELECT TOP 10
	C.Customer_Name,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Name
ORDER BY Revenue DESC;


-- 5. Revenue by Market.
SELECT 
	O.Market,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.market
ORDER BY Revenue DESC;

-- ====================================================================================
----------------------------- Profitability Analysis -------------------------------
-- ====================================================================================

-- 6. Total Profit.
SELECT SUM(Profit) AS Total_Profit
FROM sales;

-- 7. Monthly Profit Trend
SELECT 
	YEAR(O.Order_Date) AS Years,
	MONTH(O.Order_Date) AS Months,
	SUM(Profit) AS Profit
FROM sales S
INNER JOIN Orders O
ON S.Order_Id = O.Order_Id
GROUP BY YEAR(O.Order_Date), MONTH(O.Order_Date) 
ORDER BY Years, Months ASC;

-- 8. Top 10 Profitable Products
SELECT TOP 10
	P.Product_Name,
	SUM(S.Profit) AS Profit
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
ORDER BY Profit DESC;

-- 9. Top 10 Profitable Customers
SELECT TOP 10
	C.Customer_Name,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Name
ORDER BY Profits DESC;

-- 10. Profit by Market
SELECT 
	O.Market,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.market
ORDER BY Profits DESC;

-- 11. Profit Margin %
SELECT 
ROUND((SUM(Profit) /
		SUM(Sales)) * 100.00, 2)
	AS Profit_Margin
FROM sales;

-- ===================================================================================
----------------------------------- Customer Analysis --------------------------------
-- ===================================================================================

-- 12.Total Customers
SELECT 
	COUNT(DISTINCT Customer_Name) AS Total_Customers
FROM customers;

-- 13.Customers by Segment
SELECT 
	Customer_Segment,
	COUNT(DISTINCT Customer_Id) AS no_of_cust
FROM customers
GROUP BY Customer_Segment;

-- 14.Revenue by Customer Segment
SELECT 
	C.Customer_Segment,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Segment;

-- 15.Average Revenue per Customer
WITH Avg_Rev_Per_Cust AS
(
SELECT 
	C.Customer_Name,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Name
)
SELECT 
	AVG(Revenue) AS Avg_Rev_Per_Cust
FROM Avg_Rev_Per_Cust;
	
-- 16. Top 10 Customers by Order Quantity
SELECT TOP 10
	C.Customer_Name,
	COUNT(*) AS No_Orders,
	SUM(S.Order_Item_Quantity) AS Total_NO_qnty
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Name
ORDER BY Total_NO_qnty DESC;


-- 17. Customer Distribution by Country
SELECT 
	Customer_Country,
	C.Customer_Name,
	COUNT(DISTINCT C.Customer_Id) AS No_of_Cust
FROM customers C 
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id 
GROUP BY C.Customer_Country, C.Customer_Name;


-- 18. Customer Distribution by State
SELECT 
	Customer_State,
	C.Customer_Name,
	COUNT(DISTINCT C.Customer_Id) AS No_of_Cust
FROM customers C 
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id 
GROUP BY C.Customer_State, C.Customer_Name;
 
-- 19. Profit by Customer Segment
SELECT 
	C.Customer_Segment,
	SUM(S.Profit) AS Profits
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY C.Customer_Segment
ORDER BY Profits DESC;

-- 20. Top 10 Least Profitable Customers
SELECT TOP 10
	C.Customer_Name,
	SUM(S.Profit) AS Profits
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY C.Customer_Name
ORDER BY Profits ASC;

-- 21. Average Order Value per Customer
WITH Avg_Ord_Val AS
(
SELECT 
	C.Customer_Name,
	(SUM(S.Sales) / COUNT(O.Order_Id)) AS Counts
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY C.Customer_Name
)
SELECT 
	AVG(Counts) AS Avg_Ord_Val
FROM Avg_Ord_Val;

-- 22. Customer Lifetime Value
SELECT 
	C.Customer_Name,
	SUM(S.Sales) AS Cust_LT_Val
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY C.Customer_Name
ORDER BY Cust_LT_Val DESC;


-- ============================================================================================
---------------------------------- Product Analysis -------------------------------------------
-- ============================================================================================

-- 23. Revenue by Category.
SELECT 
	P.Category_Name,
	SUM(S.Sales) AS Revenue
FROM products P
INNER JOIN sales S
ON P.Product_Card_Id = S.Product_Card_Id
GROUP BY P.Category_Name
ORDER BY Revenue DESC;

-- 24. Profit by Category.
SELECT 
	P.Category_Name,
	SUM(S.Profit) AS Profits
FROM products P
INNER JOIN sales S
ON P.Product_Card_Id = S.Product_Card_Id
GROUP BY P.Category_Name
ORDER BY Profits DESC;

-- 25. Revenue by Department.
SELECT 
	P.Department_Name,
	SUM(S.Sales) AS Revenue
FROM products P
INNER JOIN sales S
ON P.Product_Card_Id = S.Product_Card_Id
GROUP BY P.Department_Name
ORDER BY Revenue DESC;

-- 26. Profit by Department.
SELECT 
	P.Department_Name,
	SUM(S.Profit) AS Profits
FROM products P
INNER JOIN sales S
ON P.Product_Card_Id = S.Product_Card_Id
GROUP BY P.Department_Name
ORDER BY Profits DESC;

-- 27. Top 10 Least Profitable Products.
SELECT TOP 10
	P.Product_Name,
	SUM(S.Profit) AS Profits
FROM products P
INNER JOIN sales S
ON P.Product_Card_Id = S.Product_Card_Id
GROUP BY P.Product_Name
ORDER BY Profits ASC;

-- 28. Average Product Revenue.
WITH Avg_Product_Revenue AS
(
    SELECT
        P.Product_Name,
        SUM(S.Sales) AS Revenue
    FROM sales S
    INNER JOIN products P
        ON S.Product_Card_Id = P.Product_Card_Id
    GROUP BY P.Product_Name
)
SELECT
    AVG(Revenue) AS Avg_Product_Revenue
FROM Avg_Product_Revenue;

--==========================================================================================================
------------------------------------------- Order Analysis ------------------------------------------------
--=========================================================================================================
-- 29. Average Order Value
WITH Avg_Ord_Val AS
(
SELECT 
	(SUM(S.Sales) / COUNT(O.Order_Id)) AS Counts
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY C.Customer_Name
)
SELECT 
	AVG(Counts) AS Avg_Ord_Val
FROM Avg_Ord_Val;

-- 30. Orders by Market
SELECT 
	Market,
	COUNT(DISTINCT Order_Id) AS Total_Orders
FROM orders
GROUP BY Market;

-- 31. Orders by Year
SELECT 
	YEAR(Order_Date) AS Years,
	COUNT(DISTINCT Order_Id) AS Total_Orders
FROM orders
GROUP BY YEAR(Order_Date)
ORDER BY Years;

-- 32. Orders by Month
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	COUNT(DISTINCT Order_Id) AS Total_Orders
FROM orders
GROUP BY YEAR(Order_Date),MONTH(Order_Date)
ORDER BY Years, Months;

-- 33. Highest Revenue Order.
SELECT TOP 3
	O.Order_Country,
	O.Order_Id,
	SUM(S.Sales) AS High_Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Order_Id,O.Order_Country
ORDER BY High_Revenue DESC;

-- 34. Highest Profit Order
SELECT TOP 3
	O.Order_Country,
	O.Order_Id,
	SUM(S.Profit) AS High_Profit
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Order_Id,O.Order_Country
ORDER BY High_Profit DESC;














