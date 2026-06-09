USE SupplychainDB;

--==========================================================================================================
------------------------------------------ Customer Analysis -----------------------------------------------
--==========================================================================================================

-- 1. Total Customers
SELECT 
	COUNT(DISTINCT Customer_Id) AS Counts
FROM customers;


-- 2. Customers by Segment
SELECT 
	Customer_Segment,
	COUNT(DISTINCT Customer_Id) AS Counts
FROM customers 
GROUP BY Customer_Segment;


-- 3. Customers by Country
SELECT 
	Customer_Country,
	COUNT(DISTINCT Customer_Id) AS Counts
FROM customers 
GROUP BY Customer_Country;


-- 4. Customers by State
SELECT 
	Customer_State,
	COUNT(DISTINCT Customer_Id) AS Counts
FROM customers 
GROUP BY Customer_State;

-- 5. Revenue by Customer Segment
SELECT 
	C.Customer_Segment,
	SUM(S.Sales) AS Revenue
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY Customer_Segment
ORDER BY Revenue DESC;


-- 6. Profit by Customer Segment
SELECT 
	C.Customer_Segment,
	SUM(S.Profit) AS Profits
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY Customer_Segment
ORDER BY Profits DESC;


-- 7. Top 10 Customers by Revenue
WITH Top_Cust AS
(
SELECT 
	C.Customer_Name,
	SUM(S.Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(S.Sales) DESC) AS rnk 
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY Customer_Name
)
SELECT * 
FROM Top_Cust
WHERE rnk <= 10;


-- 8. Top 10 Customers by Profit
WITH Top_Cust AS
(
SELECT 
	C.Customer_Name,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Profit) DESC) AS rnk 
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY Customer_Name
)
SELECT * 
FROM Top_Cust
WHERE rnk <= 10;


-- 9. Top 10 Customers by Quantity
WITH Top_Cust AS
(
SELECT 
	C.Customer_Name,
	SUM(S.Order_Item_Quantity) AS No_Of_Qnty,
	RANK() OVER(
		ORDER BY SUM(S.Order_Item_Quantity) DESC) AS rnk 
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY Customer_Name
)
SELECT * 
FROM Top_Cust
WHERE rnk <= 10;

-- 10. Least Profitable Customers
WITH Top_Cust AS
(
SELECT 
	C.Customer_Name,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Profit) ASC) AS rnk 
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY Customer_Name
)
SELECT * 
FROM Top_Cust
WHERE rnk <= 10;


-- 11. Customer Lifetime Value
SELECT 
	C.Customer_Name,
	SUM(S.Sales) AS CLV 
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY C.Customer_Name
ORDER BY CLV DESC;

-- 12. Average Revenue per Customer
SELECT
    SUM(S.Sales) * 1.0 /
    COUNT(DISTINCT C.Customer_Id)
    AS Avg_Revenue_Per_Customer
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id;


-- 13. Average Order Value per Customer
WITH Avg_Rev_Per_Ord AS
(
SELECT 
	COUNT(DISTINCT O.Order_Id) AS Counts,
	SUM(S.Sales) AS Revenue
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Order_Id
)
SELECT 
	AVG(Revenue) AS Avg_Rev_Per_Ord
FROM Avg_Rev_Per_Ord;


-- 14. Repeat Customers
SELECT
    C.Customer_Id,
    C.Customer_Name,
    COUNT(DISTINCT S.Order_Id) AS Total_Orders
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY
    C.Customer_Id,
    C.Customer_Name
HAVING COUNT(DISTINCT S.Order_Id) > 1
ORDER BY Total_Orders DESC; 


-- 15. One-Time Customers
SELECT 
	C.Customer_Name,
	COUNT(DISTINCT O.Order_Id) AS Counts
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY Customer_Name
HAVING COUNT(DISTINCT S.Order_Id) = 1; 


-- 16. Customer Concentration Analysis
WITH Cust_Concentration_Analysis AS
(
SELECT
	YEAR(O.Order_Date) AS Years,
	DATEPART(QUARTER, O.Order_Date) AS Qtr,
	C.Customer_Id,
	C.Customer_Name,
	SUM(S.Sales) AS Revenue,
	RANK() OVER(
		PARTITION BY DATEPART(QUARTER, O.Order_Date) ORDER BY SUM(S.Sales) DESC)
	AS Rnk
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY  YEAR(O.Order_Date),
	DATEPART(QUARTER, O.Order_Date),
	C.Customer_Id, 
	C.Customer_Name
)
SELECT *
FROM Cust_Concentration_Analysis
WHERE Rnk <= 3;


-- 17. Revenue Contribution % by Segment
SELECT	
	C.Customer_Segment,
	SUM(S.Sales) AS Revenue,
	ROUND(SUM(S.Sales) * 100.00 /
		SUM(SUM(S.Sales)) OVER(), 2)
	AS Revenue_Contribution
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Segment
ORDER BY Revenue;


-- 18. Profit Contribution % by Segment
SELECT	
	C.Customer_Segment,
	SUM(S.Profit) AS Profits,
	ROUND(SUM(S.Profit) * 100.00 /
		SUM(SUM(S.Profit)) OVER(), 2)
	AS Revenue_Contribution
FROM sales S
INNER JOIN customers C
ON S.Customer_Id = C.Customer_Id
GROUP BY C.Customer_Segment
ORDER BY Profits DESC;


-- 19. Customer Ranking
SELECT 
	C.Customer_Id,
	C.Customer_Name,
	SUM(S.Sales) AS Revenue,
	RANK() OVER(
		ORDER BY SUM(S.Sales) DESC) 
	AS Ranks
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY C.Customer_Id,
	C.Customer_Name;











