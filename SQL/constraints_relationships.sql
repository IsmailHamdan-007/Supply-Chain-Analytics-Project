CREATE DATABASE SupplychainDB;

USE SupplychainDB;

SELECT * FROM customers;


SELECT @@VERSION;

SELECT name, state_desc
FROM sys.databases;

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

CREATE TABLE products (
    Product_Card_Id INT,
    Product_Name NVARCHAR(100),
    Category_Id INT,
    Category_Name NVARCHAR(100),
    Department_Id INT,
    Department_Name NVARCHAR(100),
    Product_Price DECIMAL(10,2)
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products';

SELECT * FROM products
order by Product_Card_Id;

SELECT Product_Card_Id,
       COUNT(*)
FROM products
GROUP BY Product_Card_Id
HAVING COUNT(*) > 1;

CREATE TABLE orders (
    Order_Id INT PRIMARY KEY,
    Order_Date DATETIME,
    Order_Status NVARCHAR(50),
    Order_City NVARCHAR(100),
    Order_State NVARCHAR(100),
    Order_Country NVARCHAR(100),
    Order_Region NVARCHAR(100),
    Market NVARCHAR(100)
);

SELECT * FROM orders;

CREATE TABLE shipping (
    Order_Id INT,
    Shipping_Mode NVARCHAR(50),
    Delivery_Status NVARCHAR(50),
    Late_Delivery_Risk INT,
    Days_For_Shipping_Real INT,
    Days_For_Shipment_Scheduled INT,
    Shipping_Date DATETIME
);

SELECT * FROM shipping
ORDER BY Order_Id ASC;

CREATE TABLE sales_fact
(
    Order_Id BIGINT,
    Customer_Id INT,
    Product_Card_Id INT,
    Sales DECIMAL(12,2),
    Order_Item_Quantity INT,
    Benefit_Per_Order DECIMAL(12,2),
    Order_Profit_Per_Order DECIMAL(12,2)
);

select * from sales;


SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM shipping;
SELECT COUNT(*) FROM sales;

SELECT COUNT(*)
FROM sales s
LEFT JOIN customers c
    ON s.Customer_Id = c.Customer_Id
WHERE c.Customer_Id IS NULL;

SELECT COUNT(*)
FROM sales s
LEFT JOIN products p
    ON s.Product_Card_Id = p.Product_Card_Id
WHERE p.Product_Card_Id IS NULL;

SELECT COUNT(*)
FROM sales s
LEFT JOIN orders o
    ON s.Order_Id = o.Order_Id
WHERE o.Order_Id IS NULL;

SELECT COUNT(*)
FROM shipping s
LEFT JOIN orders o
    ON s.Order_Id = o.Order_Id
WHERE o.Order_Id IS NULL;

SELECT Customer_Id,
       COUNT(*)
FROM customers
GROUP BY Customer_Id
HAVING COUNT(*) > 1;

ALTER TABLE customers
ADD CONSTRAINT PK_Customers
PRIMARY KEY(Customer_Id);


SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers'
AND COLUMN_NAME = 'Customer_Id';

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales'
AND COLUMN_NAME = 'Customer_Id';

ALTER TABLE sales
ALTER COLUMN Customer_Id SMALLINT;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='sales'
AND COLUMN_NAME='Customer_Id';

ALTER TABLE sales
ADD CONSTRAINT FK_Sales_Customer
FOREIGN KEY (Customer_Id)
REFERENCES customers(Customer_Id);

-- products
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='products'
AND COLUMN_NAME='Product_Card_Id';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='sales'
AND COLUMN_NAME='Product_Card_Id';

-- orders
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='orders'
AND COLUMN_NAME='Order_Id';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='sales'
AND COLUMN_NAME='Order_Id';

ALTER TABLE sales
ALTER COLUMN Order_Id INT;

ALTER TABLE sales
ADD CONSTRAINT FK_Sales_Order
FOREIGN KEY (Order_Id)
REFERENCES orders(Order_Id);

ALTER TABLE sales
ADD CONSTRAINT FK_Sales_Product
FOREIGN KEY(Product_Card_Id)
REFERENCES products(Product_Card_Id);

SELECT Product_Card_Id,
       COUNT(*)
FROM products
GROUP BY Product_Card_Id
HAVING COUNT(*) > 1;

SELECT COUNT(*), COUNT(DISTINCT Customer_Id)
FROM customers;

SELECT COUNT(*), COUNT(DISTINCT Product_Card_Id)
FROM products;

SELECT COUNT(*), COUNT(DISTINCT Order_Id)
FROM orders;

SELECT *
FROM products
WHERE Product_Card_Id IN
(
278,
365,
502,
627,
1360
)
ORDER BY Product_Card_Id;

SELECT DISTINCT *
INTO Products_
FROM products;

SELECT Product_Card_Id,
       COUNT(*) AS cnt
FROM products
GROUP BY Product_Card_Id
HAVING COUNT(*) > 1;

SELECT DISTINCT *
INTO products_new
FROM products;

SELECT COUNT(*),
       COUNT(DISTINCT Product_Card_Id)
FROM products_new;

ALTER TABLE products_new
ADD CONSTRAINT PK_Products
PRIMARY KEY(Product_Card_Id);

SELECT *
FROM products_new
WHERE Product_Card_Id IS NULL;

SELECT COUNT(*)
FROM products_new
WHERE Product_Card_Id IS NULL;

ALTER TABLE products_new
ALTER COLUMN Product_Card_Id INT NOT NULL;

ALTER TABLE products_new
ADD CONSTRAINT PK_Products
PRIMARY KEY (Product_Card_Id);

SELECT DISTINCT *
INTO products_new
FROM products;

SELECT COUNT(*)
FROM products_new
WHERE Product_Card_Id IS NULL;

SELECT COLUMN_NAME,
       IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='products_new'
AND COLUMN_NAME='Product_Card_Id';

ALTER TABLE sales
ADD CONSTRAINT FK_Sales_Customer
FOREIGN KEY (Customer_Id)
REFERENCES customers(Customer_Id);

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='sales'
AND COLUMN_NAME='Order_Id';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='orders'
AND COLUMN_NAME='Order_Id';

ALTER TABLE sales
ADD CONSTRAINT FK_Sales_Order
FOREIGN KEY (Order_Id)
REFERENCES orders(Order_Id);

ALTER TABLE sales
ADD CONSTRAINT FK_Sales_Product
FOREIGN KEY (Product_Card_Id)
REFERENCES products_new(Product_Card_Id);

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='shipping'
AND COLUMN_NAME='Order_Id';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='orders'
AND COLUMN_NAME='Order_Id';

ALTER TABLE shipping
ADD CONSTRAINT FK_Shipping_Order
FOREIGN KEY (Order_Id)
REFERENCES orders(Order_Id);

-- Customer IDs in sales not found in customers
SELECT COUNT(*)
FROM sales s
LEFT JOIN customers c
ON s.Customer_Id = c.Customer_Id
WHERE c.Customer_Id IS NULL;

-- Product IDs in sales not found in products_new
SELECT COUNT(*)
FROM sales s
LEFT JOIN products_new p
ON s.Product_Card_Id = p.Product_Card_Id
WHERE p.Product_Card_Id IS NULL;

-- Order IDs in sales not found in orders
SELECT COUNT(*)
FROM sales s
LEFT JOIN orders o
ON s.Order_Id = o.Order_Id
WHERE o.Order_Id IS NULL;

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable
FROM sys.foreign_keys fk;

EXEC sp_rename 'products', 'products_old';

EXEC sp_rename 'products_new', 'products';

CREATE INDEX IX_Sales_CustomerId
ON sales(Customer_Id);

CREATE INDEX IX_Sales_OrderId
ON sales(Order_Id);

CREATE INDEX IX_Sales_ProductId
ON sales(Product_Card_Id);

CREATE INDEX IX_Shipping_OrderId
ON shipping(Order_Id);

