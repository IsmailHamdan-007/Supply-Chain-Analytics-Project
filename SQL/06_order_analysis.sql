USE SupplychainDB;

SELECT * FROM orders;

--=================================================================================================
------------------------------------ ORDER ANALYSIS -----------------------------------------------
--=================================================================================================

-- 1. Total Orders
SELECT 
	COUNT(DISTINCT Order_Id) AS Total_Orders
FROM orders;


-- 2. Order Trend Analysis (Yearly & Monthly)
SELECT 
	YEAR(Order_Date) AS Years,
	MONTH(Order_Date) AS Months,
	COUNT(DISTINCT Order_Id) AS orders
FROM Orders
GROUP BY YEAR(Order_Date),
	MONTH(Order_Date)
ORDER BY Years, Months;


-- 3. Order Distribution by Market and Country.
SELECT 
	Market,
	Order_Country,
	COUNT(DISTINCT Order_Id) AS Total_Dist
FROM orders 
GROUP BY Market, Order_Country
ORDER BY Total_Dist DESC;


-- 4. Average Order Value (AOV)
SELECT 
	ROUND(SUM(S.Sales) /
		COUNT(DISTINCT O.Order_Id), 2)
	AS Avg_Ord_Val
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id;


-- 5. Top Performing Orders by Revenue and Profit
WITH Order_Ranking AS
(
    SELECT
        O.Order_Id,
        SUM(S.Sales) AS Revenue,
        SUM(S.Profit) AS Profit,
        RANK() OVER(
            ORDER BY SUM(S.Sales) DESC
        ) AS Revenue_Rnk
    FROM sales S
    INNER JOIN orders O
    ON S.Order_Id = O.Order_Id
    GROUP BY O.Order_Id
)
SELECT *
FROM Order_Ranking
WHERE Revenue_Rnk <= 5;


-- 6. Bottom Performing Orders by Revenue and Profit
WITH Order_Ranking AS
(
    SELECT
        O.Order_Id,
        SUM(S.Sales) AS Revenue,
        SUM(S.Profit) AS Profit,
        RANK() OVER(
            ORDER BY SUM(S.Sales) ASC
        ) AS Revenue_Rnk
    FROM sales S
    INNER JOIN orders O
    ON S.Order_Id = O.Order_Id
    GROUP BY O.Order_Id
)
SELECT *
FROM Order_Ranking
WHERE Revenue_Rnk <= 5;

-- 7. Orders per Customer
SELECT 
	C.Customer_Id,
	C.Customer_Name,
	COUNT(DISTINCT O.Order_Id) AS Orders_Per_Cust
FROM customers C
INNER JOIN sales S
	ON C.Customer_Id = S.Customer_Id
INNER JOIN orders O
	ON S.Order_Id = O.Order_Id
GROUP BY C.Customer_Id,
	C.Customer_Name
ORDER BY Orders_Per_Cust DESC;



-- 8. Orders by Product Category and Department
SELECT 
	P.Category_Name,
	P.Department_Name,
	COUNT(DISTINCT O.Order_Id) AS Orders
FROM products P
INNER JOIN sales S
	ON P.Product_Card_Id = S.Product_Card_Id
INNER JOIN orders O
	ON S.Order_Id = O.Order_Id
GROUP BY P.Category_Name,
	P.Department_Name
ORDER BY Orders DESC;


-- 9. Revenue per Order
SELECT 
	O.Order_Id,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Order_Id;


-- 10. Profit per Order
SELECT 
	O.Order_Id,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Order_Id;

-- 11. Average Quantity per Order
WITH Order_Qty AS
(
    SELECT
        Order_Id,
        SUM(Order_Item_Quantity) AS Total_Qty
    FROM sales
    GROUP BY Order_Id
)
SELECT
    AVG(Total_Qty) AS Avg_Qty_Per_Order
FROM Order_Qty;


