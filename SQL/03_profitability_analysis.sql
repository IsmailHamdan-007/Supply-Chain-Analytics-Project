USE SupplychainDB;

-- 1. Total Profit
SELECT 
	SUM(Profit) AS Total_Profits
FROM sales;


-- 2. Monthly Profit Trend
SELECT 
	YEAR(O.Order_Date) AS Years,
	MONTH(O.Order_Date) AS Months,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY YEAR(O.Order_Date),
	MONTH(O.Order_Date)
ORDER BY Years, Months;


-- 3. Profit Margin
SELECT 
	ROUND(SUM(Profit) * 100.00 /
		SUM(Sales), 2)
	AS Profit_Margin
FROM sales;


-- 4. Profit by Market
SELECT 
	O.Market,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN orders O 
ON S.Order_Id = O.Order_Id
GROUP BY O.Market
ORDER BY Profits;


-- 5. Profit by Category
SELECT 
	P.Category_Name,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name
ORDER BY Profits;

-- 6. Profit by Department
SELECT 
	P.Department_Name,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name
ORDER BY Profits;


-- 7. Top Profitable Products
WITH Prof_Prod AS 
(
SELECT 
	P.Product_Name,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Profit) DESC) AS rnk
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
)
SELECT *
FROM Prof_Prod
WHERE rnk <= 3; 


-- 8. Least Profitable Products
WITH Prof_Prod AS 
(
SELECT 
	P.Product_Name,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Profit) ASC) AS rnk
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
)
SELECT *
FROM Prof_Prod
WHERE rnk <= 3; 


-- 9. Loss Making Products
SELECT 
	P.Product_Name,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Product_Name
HAVING SUM(S.Profit) < 0;


-- 10. Top 10 Profitable Customers
WITH Top_10_Prof_Cust AS
(
SELECT 
	C.Customer_Name,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Profit) DESC)
	AS rnk
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY C.Customer_Name
)
SELECT *
FROM Top_10_Prof_Cust
WHERE rnk <= 10;


-- 11. Bottom 10 Profitable Customers
WITH Top_10_Prof_Cust AS
(
SELECT 
	C.Customer_Name,
	SUM(S.Profit) AS Profits,
	RANK() OVER(
		ORDER BY SUM(S.Profit) ASC)
	AS rnk
FROM customers C
INNER JOIN sales S
ON C.Customer_Id = S.Customer_Id
GROUP BY C.Customer_Name
)
SELECT *
FROM Top_10_Prof_Cust
WHERE rnk <= 10;


-- 12. Loss Making Categories
SELECT 
	P.Category_Name,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P 
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name
HAVING SUM(S.Profit) < 0;


-- 13. Loss Making Departments
SELECT 
	P.Department_Name,
	SUM(S.Profit) AS Profits
FROM sales S
INNER JOIN products P 
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name
HAVING SUM(S.Profit) < 0;


-- 14. Profit Contribution % by Market
SELECT 
	O.Market,
	ROUND(SUM(S.Profit) * 100.00 /
	SUM(SUM(S.Profit)) OVER(), 2)
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Market;


-- 15. Profit Contribution % by Category
SELECT 
	P.Category_Name,
	ROUND(SUM(S.Profit) * 100.00 /
	SUM(SUM(S,Profit)) OVER(), 2) AS Cont_Percent
FROM sales S
INNER JOIN products P 
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name;


-- 16. Profit Contribution % by Department
SELECT 
	P.Department_Name,
	ROUND(SUM(S.Profit) * 100.00 /
	SUM(SUM(S.Profit)) OVER(), 2) AS Cont_Percent
FROM sales S
INNER JOIN products P 
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name;


-- 17. Profit Margin %
SELECT 
	ROUND(SUM(Profit) * 100.00 /
		SUM(Sales), 2) AS Profit_Margin
FROM sales;


-- 18. Profit Margin by Market
SELECT 
	O.Market,
	ROUND(SUM(Profit) * 100.00 /
		SUM(Sales), 2) AS Profit_Margin
FROM sales S
INNER JOIN orders O
ON S.Order_Id = O.Order_Id
GROUP BY O.Market;


-- 19. Profit Margin by Category
SELECT 
	P.Category_Name,
	ROUND(SUM(Profit) * 100.00 /
		SUM(Sales), 2) AS Profit_Margin
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name;


-- 20. Profit Margin by Department
SELECT 
	P.Department_Name,
	ROUND(SUM(Profit) * 100.00 /
		SUM(Sales), 2) AS Profit_Margin
FROM sales S
INNER JOIN products P
ON S.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Department_Name;






















