# Supply Chain Analytics Project

## Overview

This project demonstrates an end-to-end data analytics workflow using Python, Pandas, and SQL Server. The objective was to transform a raw supply chain dataset into a structured relational database, establish relationships between business entities, and prepare the data for analytical reporting.

---

## Tools & Technologies

* Python
* Pandas
* SQL Server
* SQLAlchemy
* PyODBC
* Jupyter Notebook
* GitHub

---

## Dataset

**Source:** DataCo Supply Chain Dataset

The original dataset was imported into Python and cleaned using Pandas before being transformed into a relational database model.

---

## Project Workflow

### 1. Data Cleaning & Preparation (Python + Pandas)

Performed:

* Data loading using Pandas
* Encoding handling (Latin-1)
* Column exploration and validation
* Data quality checks
* Duplicate detection
* Data type validation
* Dataset splitting into multiple business entities

Notebook:

* `1.data_cleaning.ipynb`

---

### 2. Data Modeling

The original dataset was split into the following tables:

#### Customers

Contains customer information.

#### Products

Contains product, category, and department information.

#### Orders

Contains order details and geographic information.

#### Shipping

Contains shipping performance and delivery information.

#### Sales Fact

Contains transactional sales metrics.

---

### 3. SQL Server Database Design

Created:

* Database: `SupplychainDB`
* Relational tables
* Primary Keys
* Foreign Keys
* Indexes

SQL Script:

* `constraints_relationships.sql`

---

## Database Schema

### Customers

| Column           |
| ---------------- |
| Customer_Id      |
| Customer_Fname   |
| Customer_Lname   |
| Customer_City    |
| Customer_State   |
| Customer_Country |
| Customer_Segment |

---

### Products

| Column          |
| --------------- |
| Product_Card_Id |
| Product_Name    |
| Category_Id     |
| Category_Name   |
| Department_Id   |
| Department_Name |
| Product_Price   |

---

### Orders

| Column        |
| ------------- |
| Order_Id      |
| Order_Date    |
| Order_Status  |
| Order_City    |
| Order_State   |
| Order_Country |
| Order_Region  |
| Market        |

---

### Shipping

| Column                      |
| --------------------------- |
| Order_Id                    |
| Shipping_Mode               |
| Delivery_Status             |
| Late_Delivery_Risk          |
| Days_For_Shipping_Real      |
| Days_For_Shipment_Scheduled |
| Shipping_Date               |

---

### Sales Fact

| Column                 |
| ---------------------- |
| Order_Id               |
| Customer_Id            |
| Product_Card_Id        |
| Sales                  |
| Order_Item_Quantity    |
| Benefit_Per_Order      |
| Order_Profit_Per_Order |

---

## Relationships

Implemented Referential Integrity using Foreign Keys:

* Customers → Sales
* Products → Sales
* Orders → Sales
* Orders → Shipping

Data quality checks were performed before creating constraints to identify duplicate keys and datatype mismatches.

---

## Performance Optimization

Created indexes on:

* Customer_Id
* Product_Card_Id
* Order_Id

to improve query performance and join operations.

---

## Files Included

```text
Supply_Chain_Mgmt
│
├── customers.csv
├── products.csv
├── orders.csv
├── shipping.csv
├── sales_fact.csv
│
├── 1.data_cleaning.ipynb
├── 2.basics.ipynb
├── 3.sql.ipynb
│
├── constraints_relationships.sql
│
└── README.md
```

---

## Skills Demonstrated

### SQL

* Database Design
* Data Modeling
* Primary Keys
* Foreign Keys
* Indexing
* Referential Integrity

### Python & Pandas

* Data Cleaning
* Data Validation
* Data Transformation
* Exploratory Analysis

### Data Analytics

* ETL Workflow
* Relational Modeling
* Data Quality Assessment

---

## Key Learning Outcomes

* Converting a raw dataset into a relational database structure.
* Handling duplicate records and datatype inconsistencies.
* Implementing primary and foreign key relationships.
* Loading large datasets into SQL Server using Python.
* Optimizing database performance using indexes.

---

## Future Enhancements

* Business Analysis using SQL
* Advanced SQL Queries
* Window Functions
* KPI Reporting
* Power BI Dashboard Development
* Sales & Supply Chain Performance Analytics

---

## Author

Aspiring Data Analyst

Skills: SQL | Python | Pandas | Excel | Power BI | Data Modeling | Business Analysis
