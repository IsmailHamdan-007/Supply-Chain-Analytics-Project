USE SupplychainDB;

SELECT * FROM shipping;

--=================================================================================================
---------------------------------- SHIPPING ANALYSIS ----------------------------------------------
--=================================================================================================

-- 1. Shipping Time Statistics
SELECT 
	MIN(Days_For_Shipping_Real) AS Min_Shipping_Days,
	MAX(Days_For_Shipping_Real) AS Max_Shipping_Days,
	AVG(Days_For_Shipping_Real) AS Avg_Shipping_Days
FROM shipping;


-- 2. Shipping Time Analysis by Market
SELECT
    O.Market,
    AVG(S.Days_For_Shipping_Real) AS Avg_Shipping_Days
FROM shipping S
INNER JOIN orders O
    ON S.Order_Id = O.Order_Id
GROUP BY O.Market;


-- 3. Shipping Time Analysis by Country
SELECT
    O.Order_Country,
    AVG(S.Days_For_Shipping_Real) AS Avg_Shipping_Days
FROM shipping S
INNER JOIN orders O
    ON S.Order_Id = O.Order_Id
GROUP BY O.Order_Country;


-- 4. Shipping Time Analysis by Shipping Mode
SELECT 
	Shipping_Mode,
	AVG(Days_For_Shipping_Real) AS Avg_Shipping_Days
FROM shipping
GROUP BY Shipping_Mode;


-- 5. Delivery Status Analysis
-- (Late Deliveries, Early Deliveries, and Late Delivery Percentage)
SELECT
    COUNT(CASE
            WHEN Delivery_Status = 'Late delivery'
            THEN 1
          END) AS Late_Deliveries,
    COUNT(CASE
            WHEN Delivery_Status = 'Advance shipping'
            THEN 1
          END) AS Early_Deliveries,
    ROUND(
        COUNT(CASE
                WHEN Delivery_Status = 'Late delivery'
                THEN 1
              END) * 100.0
        / COUNT(*),2 )
	AS Late_Delivery_Percentage
FROM shipping;


-- 6. Average Shipping Time by Product Hierarchy
-- (Category and Department)
SELECT 
	P.Category_Name,
	P.Department_Name,
	AVG(Days_For_Shipping_Real) AS Avg_Shipping_Days
FROM shipping S
INNER JOIN orders O
	ON S.Order_Id = O.Order_Id
INNER JOIN sales SI
	ON O.Order_Id = SI.Order_Id
INNER JOIN products P
	ON SI.Product_Card_Id = P.Product_Card_Id
GROUP BY P.Category_Name,
	P.Department_Name
ORDER BY Avg_Shipping_Days;


-- 7. Revenue and Profit Impact by Shipping Mode
SELECT 
	S.Shipping_Mode,
	SUM(SI.Sales) AS Revenue,
	SUM(SI.Profit) AS Profits
FROM shipping S
INNER JOIN orders O
	ON S.Order_Id = O.Order_Id
INNER JOIN sales SI
	ON O.Order_Id = SI.Order_Id
GROUP BY S.Shipping_Mode
ORDER BY Revenue DESC;


-- 8. Shipping Performance Ranking
-- (Ranking Markets, Countries, or Shipping Modes based on Delivery Performance)
WITH Shipping_Performance AS
(
    SELECT
        Shipping_Mode,
        AVG(CAST(Days_For_Shipping_Real AS DECIMAL(10,2))) AS Avg_Shipping_Days
    FROM shipping
    GROUP BY Shipping_Mode
)
SELECT
    Shipping_Mode,
    Avg_Shipping_Days,
    RANK() OVER(ORDER BY Avg_Shipping_Days ASC) AS Performance_Rank
FROM Shipping_Performance;

WITH Market_Country_Performance AS
(
    SELECT
        O.Market,
		O.Order_Country,
        AVG(CAST(S.Days_For_Shipping_Real AS DECIMAL(10,2))) AS Avg_Shipping_Days
    FROM shipping S
    INNER JOIN orders O
        ON S.Order_Id = O.Order_Id
    GROUP BY O.Market,
	O.Order_Country
)
SELECT
    Market,
    Avg_Shipping_Days,
    RANK() OVER(ORDER BY Avg_Shipping_Days ASC) AS Performance_Rank,
	Order_Country,
	 RANK() OVER(ORDER BY Avg_Shipping_Days ASC) AS Performance_Rank
FROM Market_Country_Performance;

