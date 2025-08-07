# SQL
# RFM Segmentation

RFM (Recency, Frequency, Monetary) segmentation is a method used by businesses to categorize customers based on their transactional behavior. This segmentation approach helps in understanding customer value and behavior, enabling targeted marketing and customer relationship management strategies.

## Why we should go through in this process

RFM segmentation involves calculating recency, frequency, and monetary scores for each customer and then categorizing them into segments based on these scores. The provided SQL script segments customers into different categories, such as 'Churned Customer', 'Slipping Away, Cannot Lose', 'New Customers', 'Potential Churners', 'Active', and 'Loyal'.


## Database Setup

- Create a database named `RFM_SALES`.
```sql
CREATE DATABASE IF NOT EXISTS RFM_SALES;
USE RFM_SALES;
CREATE TABLE SALES_SAMPLE_DATA (
    ORDERNUMBER INT(8),
    QUANTITYORDERED DECIMAL(8,2),
    PRICEEACH DECIMAL(8,2),
    ORDERLINENUMBER INT(3),
    SALES DECIMAL(8,2),
    ORDERDATE VARCHAR(16),
    STATUS VARCHAR(16),
    QTR_ID INT(1),
    MONTH_ID INT(2),
    YEAR_ID INT(4),
    PRODUCTLINE VARCHAR(32),
    MSRP INT(8),
    PRODUCTCODE VARCHAR(16),
    CUSTOMERNAME VARCHAR(64),
    PHONE VARCHAR(32),
    ADDRESSLINE1 VARCHAR(64),
    ADDRESSLINE2 VARCHAR(64),
    CITY VARCHAR(16),
    STATE VARCHAR(16),
    POSTALCODE VARCHAR(16),
    COUNTRY VARCHAR(24),
    TERRITORY VARCHAR(24),
    CONTACTLASTNAME VARCHAR(16),
    CONTACTFIRSTNAME VARCHAR(16),
    DEALSIZE VARCHAR(10)
);
```
- Import wizard data

## Dataset Exploration

```sql
SELECT * FROM SALES_SAMPLE_DATA LIMIT 5;
```
-- OUTPUT --
| ORDERNUMBER | QUANTITYORDERED | PRICEEACH | ORDERLINENUMBER | SALES   | ORDERDATE | STATUS  | QTR_ID | MONTH_ID | YEAR_ID | PRODUCTLINE | MSRP | PRODUCTCODE | CUSTOMERNAME          | PHONE       | ADDRESSLINE1            | ADDRESSLINE2 | CITY          | STATE | POSTALCODE | COUNTRY | TERRITORY | CONTACTLASTNAME | CONTACTFIRSTNAME | DEALSIZE |
|-------------|------------------|-----------|------------------|---------|-----------|---------|--------|----------|---------|-------------|------|-------------|-----------------------|-------------|-------------------------|--------------|---------------|-------|------------|---------|-----------|-----------------|------------------|----------|
| 10107       | 30.00            | 95.70     | 2                | 2871.00 | 24/2/03   | Shipped | 1      | 2        | 2003    | Motorcycles | 95   | S10_1678    | Land of Toys Inc.     | 2125557818  | 897 Long Airport Avenue |              | NYC           | NY    | 10022      | USA     | NA        | Yu              | Kwai             | Small    |
| 10121       | 34.00            | 81.35     | 5                | 2765.90 | 7/5/03    | Shipped | 2      | 5        | 2003    | Motorcycles | 95   | S10_1678    | Reims Collectables    | 26.47.1555  | 59 rue de l'Abbaye     |              | Reims         |       | 51100      | France  | EMEA       | Henriot         | Paul             | Small    |
| 10134       | 41.00            | 94.74     | 2                | 3884.34 | 1/7/03    | Shipped | 3      | 7        | 2003    | Motorcycles | 95   | S10_1678    | Lyon Souveniers       | +33 1 46 62 7555 | 27 rue du Colonel Pierre Avia |              | Paris         |       | 75508      | France  | EMEA       | Da Cunha        | Daniel           | Medium   |
| 10145       | 45.00            | 83.26     | 6                | 3746.70 | 25/8/03   | Shipped | 3      | 8        | 2003    | Motorcycles | 95   | S10_1678    | Toys4GrownUps.com     | 6265557265  | 78934 Hillside Dr.     |              | Pasadena      | CA    | 90003      | USA     | NA        | Young           | Julie            | Medium   |
| 10159       | 49.00            | 100.00    | 14               | 5205.27 | 10/10/03  | Shipped | 4      | 10       | 2003    | Motorcycles | 95   | S10_1678    | Corporate Gift Ideas Co. | 6505551386  | 7734 Strong St.        |              | San Francisco | CA    |            | USA     | NA        | Brown           | Julie            | Medium   |

```sql
SELECT COUNT(*) FROM SALES_SAMPLE_DATA;-- 2823
```
-- OUTPUT --
| COUNT(*) |
|----------|
| 2823     |

## Checking unique values
```sql
select distinct status from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| status     |
|------------|
| Shipped    |
| Disputed   |
| In Process |
| Cancelled  |
| On Hold    |
| Resolved   |

```sql
select distinct year_id from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| year_id |
|---------|
| 2003    |
| 2004    |
| 2005    |

```sql
select distinct PRODUCTLINE from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| PRODUCTLINE      |
|------------------|
| Motorcycles      |
| Classic Cars     |
| Trucks and Buses |
| Vintage Cars     |
| Planes           |
| Ships            |
| Trains           |

```sql
select distinct COUNTRY from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| COUNTRY     |
|-------------|
| USA         |
| France      |
| Norway      |
| Australia   |
| Finland     |
| Austria     |
| UK          |
| Spain       |
| Sweden      |
| Singapore   |
| Canada      |
| Japan       |
| Italy       |
| Denmark     |
| Belgium     |
| Philippines |
| Germany     |
| Switzerland |
| Ireland     |

```sql
select distinct DEALSIZE from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| DEALSIZE |
|----------|
| Small    |
| Medium   |
| Large    |

```sql
select distinct TERRITORY from SALES_SAMPLE_DATA;
```
-- OUTPUT --
| TERRITORY |
|-----------|
| NA        |
| EMEA      |
| APAC      |
| Japan     |

## Analysis

**This SQL query calculates the RFM (Recency, Frequency, Monetary) values for each customer in the dataset**
```sql
SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES),0) AS MonetaryValue,
    COUNT(DISTINCT ORDERNUMBER) AS Frequency,
    -- MAX(STR_TO_DATE(ORDERDATE,' %d/%m/%y')) AS EACH_CUSTOMERS_LAST_TRANSACTION_DATE,
    -- (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA) AS BUSINESS_LAST_TRANSACTION_DATE,
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA))   AS Recency
FROM SALES_SAMPLE_DATA
GROUP BY CUSTOMERNAME;
```
-- OUTPUT --
| CUSTOMERNAME                | MonetaryValue | Frequency | Recency |
|-----------------------------|---------------|-----------|---------|
| Alpha Cognac                | 70488         | 3         | 64     |
| Amica Models & Co.          | 94117         | 2         | 264    |
| Anna's Decorations, Ltd     | 153996        | 4         | 83     |
| Atelier graphique           | 24180         | 3         | 187    |
| Australian Collectables, Ltd| 64591         | 3         | 22     |
| ........................  | .......       | ....        | ...    |


**This SQL code creates a view named RFM_SEGMENT, which calculates the RFM (Recency, Frequency, Monetary) scores and combines them into a single RFM category combination for each customer.**
```sql
CREATE VIEW RFM_SEGMENT AS 
WITH RFM_INITIAL_CALC AS (
   SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES),0) AS MonetaryValue,
    COUNT(DISTINCT ORDERNUMBER) AS Frequency,
    -- MAX(STR_TO_DATE(ORDERDATE,' %d/%m/%y')) AS EACH_CUSTOMERS_LAST_TRANSACTION_DATE,
    -- (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA) AS BUSINESS_LAST_TRANSACTION_DATE,
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA)) * (-1) AS Recency
FROM SALES_SAMPLE_DATA
GROUP BY CUSTOMERNAME
),
RFM_SCORE_CALC AS (
    SELECT 
        C.*,
        NTILE(4) OVER (ORDER BY C.Recency DESC) AS RFM_RECENCY_SCORE,
        NTILE(4) OVER (ORDER BY C.Frequency ASC) AS RFM_FREQUENCY_SCORE,
        NTILE(4) OVER (ORDER BY C.MonetaryValue ASC) AS RFM_MONETARY_SCORE
    FROM 
        RFM_INITIAL_CALC AS C
)
SELECT
    R.CUSTOMERNAME,
    (R.RFM_RECENCY_SCORE + R.RFM_FREQUENCY_SCORE + R.RFM_MONETARY_SCORE) AS TOTAL_RFM_SCORE,
    CONCAT_WS(
		'', R.RFM_RECENCY_SCORE, R.RFM_FREQUENCY_SCORE, R.R.RFM_MONETARY_SCORE
    ) AS RFM_CATEGORY_COMBINATION
FROM 
    RFM_SCORE_CALC AS R; 

SELECT * FROM RFM_SEGMENT;
```
-- OUTPUT --
| CUSTOMERNAME            | TOTAL_RFM_SCORE | RFM_CATEGORY_COMBINATION |
|-------------------------|-----------------|--------------------------|
| Boards & Toys Co.       | 6               | 321                      |
| Atelier graphique       | 5               | 221                      |
| Auto-Moto Classics Inc. | 7               | 331                      |
| .....         | ...               | ...                      |

```sql
SELECT DISTINCT RFM_CATEGORY_COMBINATION 
    FROM RFM_SEGMENT
ORDER BY 1;
```
-- OUTPUT --
| RFM_CATEGORY_COMBINATION |
|--------------------------|
| 111                      |
| 112                      |
| 113                      |
| 123                      |
| 124                      |
| 211                      |

**This SQL code segment assigns a customer segment label based on their RFM category combination**
```sql

SELECT 
    CUSTOMERNAME,
    CASE
        WHEN RFM_CATEGORY_COMBINATION IN (111, 112, 121, 123, 132, 211, 211, 212, 114, 141) THEN 'CHURNED CUSTOMER'
        WHEN RFM_CATEGORY_COMBINATION IN (133, 134, 143, 244, 334, 343, 344, 144) THEN 'SLIPPING AWAY, CANNOT LOSE'
        WHEN RFM_CATEGORY_COMBINATION IN (311, 411, 331) THEN 'NEW CUSTOMERS'
        WHEN RFM_CATEGORY_COMBINATION IN (222, 231, 221,  223, 233, 322) THEN 'POTENTIAL CHURNERS'
        WHEN RFM_CATEGORY_COMBINATION IN (323, 333,321, 341, 422, 332, 432) THEN 'ACTIVE'
        WHEN RFM_CATEGORY_COMBINATION IN (433, 434, 443, 444) THEN 'LOYAL'
    ELSE 'CANNOT BE DEFINED'
    END AS CUSTOMER_SEGMENT

FROM RFM_SEGMENT;
```
-- OUTPUT --
| CUSTOMERNAME            | CUSTOMER_SEGMENT   |
|-------------------------|---------------------|
| Boards & Toys Co.       | ACTIVE              |
| Atelier graphique       | POTENTIAL CHURNERS |
| Auto-Moto Classics Inc. | NEW CUSTOMERS       |
| Microscale Inc.         | CHURNED CUSTOMER    |
| .........           | ......            |
**This SQL code utilizes a common table expression (CTE) named CTE1 to assign customer segments based on their RFM category combinations. It then counts the number of customers in each segment and presents the result.**
```sql
WITH CTE1 AS
(SELECT 
    CUSTOMERNAME,
    CASE
        WHEN RFM_CATEGORY_COMBINATION IN (111, 112, 121, 123, 132, 211, 211, 212, 114, 141) THEN 'CHURNED CUSTOMER'
        WHEN RFM_CATEGORY_COMBINATION IN (133, 134, 143, 244, 334, 343, 344, 144) THEN 'SLIPPING AWAY, CANNOT LOSE'
        WHEN RFM_CATEGORY_COMBINATION IN (311, 411, 331) THEN 'NEW CUSTOMERS'
        WHEN RFM_CATEGORY_COMBINATION IN (222, 231, 221,  223, 233, 322) THEN 'POTENTIAL CHURNERS'
        WHEN RFM_CATEGORY_COMBINATION IN (323, 333,321, 341, 422, 332, 432) THEN 'ACTIVE'
        WHEN RFM_CATEGORY_COMBINATION IN (433, 434, 443, 444) THEN 'LOYAL'
    ELSE 'CANNOT BE DEFINED'
    END AS CUSTOMER_SEGMENT
FROM RFM_SEGMENT)

SELECT 
    CUSTOMER_SEGMENT, count(*) as Number_of_Customers
FROM CTE1
GROUP BY 1
ORDER BY 2 DESC;
```
-- OUTPUT --
| CUSTOMER_SEGMENT          | Number_of_Customers |
|---------------------------|---------------------|
| CHURNED CUSTOMER          | 20                  |
| ACTIVE                    | 18                  |
| CANNOT BE DEFINED         | 15                  |
| LOYAL                     | 14                  |
| POTENTIAL CHURNERS        | 13                  |
| SLIPPING AWAY, CANNOT LOSE| 8                   |
| NEW CUSTOMERS             | 4                   |




- Calculate recency, frequency, and monetary scores for each customer.
- Segment customers into categories based on RFM scores.

# Retail Sales Cohort Analysis Using SQL
# Project Overview
This project analyzes retail sales data to perform cohort analysis—a powerful method to understand customer retention and revenue trends over time. Customers are grouped by their first purchase month, then tracked across subsequent months for retention and revenue behavior.

# The analysis includes:

Customer retention by cohort month

Revenue retention by cohort month

The dataset is stored in the SALES.RETAIL table, and all analysis is done with SQL leveraging window functions, common table expressions (CTEs), and date manipulation.

Dataset Details
Database: SALES

Table: RETAIL

Key Columns:

InvoiceNo — unique invoice identifier

CustomerID — unique customer identifier

InvoiceDate — invoice date/time (string format: 'mm/dd/yyyy hh:mm')

Quantity — number of items purchased

UnitPrice — price per item

# Setup

``` CREATE DATABASE IF NOT EXISTS SALES;
USE SALES; 

# Data Exploration
# Preview first 1000 rows

``` SELECT * FROM SALES.RETAIL LIMIT 1000; ```

Total records count

``` SELECT COUNT(*) FROM SALES.RETAIL; ```

# Records with missing CustomerID

``` SELECT COUNT(*) FROM SALES.RETAIL WHERE CUSTOMERID = ''; ```

# Most recent invoice date

``` SELECT MAX(InvoiceDate) FROM SALES.RETAIL; ```
# Convert InvoiceDate string to DATETIME
```
SELECT 
  INVOICEDATE,
  STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE_IN_DATE
FROM RETAIL
LIMIT 5;
```
# Revenue Calculation per Invoice Line
```
SELECT 
  InvoiceNo, 
  CUSTOMERID, 
  STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE, 
  ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
FROM RETAIL
WHERE CUSTOMERID IS NOT NULL AND CUSTOMERID <> ''
ORDER BY CUSTOMERID
LIMIT 5;
```
# Customer Retention Cohort Analysis
Groups customers by their first purchase month, then counts how many customers from each cohort made purchases in the subsequent months.
```
WITH CTE1 AS (
  SELECT 
    InvoiceNo, 
    CUSTOMERID, 
    STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE, 
    ABS(ROUND(QUANTITY * UNITPRICE, 2)) AS REVENUE
  FROM RETAIL
  WHERE CUSTOMERID IS NOT NULL AND CUSTOMERID <> ''
),
CTE2 AS (
  SELECT 
    InvoiceNo, 
    CUSTOMERID, 
    INVOICEDATE, 
    DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH,
    DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
    REVENUE
  FROM CTE1
),
CTE3 AS (
  SELECT 
    CUSTOMERID, 
    FIRST_PURCHASE_MONTH,
    CONCAT(
      'Month_', 
      PERIOD_DIFF(
        EXTRACT(YEAR_MONTH FROM PURCHASE_MONTH),
        EXTRACT(YEAR_MONTH FROM FIRST_PURCHASE_MONTH)
      )
    ) AS COHORT_MONTH
  FROM CTE2
)
SELECT 
  FIRST_PURCHASE_MONTH AS Cohort,
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_0', CUSTOMERID, NULL)) AS "Month_0",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_1', CUSTOMERID, NULL)) AS "Month_1",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_2', CUSTOMERID, NULL)) AS "Month_2",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_3', CUSTOMERID, NULL)) AS "Month_3",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_4', CUSTOMERID, NULL)) AS "Month_4",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_5', CUSTOMERID, NULL)) AS "Month_5",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_6', CUSTOMERID, NULL)) AS "Month_6",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_7', CUSTOMERID, NULL)) AS "Month_7",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_8', CUSTOMERID, NULL)) AS "Month_8",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_9', CUSTOMERID, NULL)) AS "Month_9",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_10', CUSTOMERID, NULL)) AS "Month_10",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_11', CUSTOMERID, NULL)) AS "Month_11",
  COUNT(DISTINCT IF(COHORT_MONTH = 'Month_12', CUSTOMERID, NULL)) AS "Month_12"
FROM CTE3
GROUP BY FIRST_PURCHASE_MONTH
ORDER BY FIRST_PURCHASE_MONTH;
```
# Revenue Retention Cohort Analysis
Sums revenue for each cohort over subsequent months.
```
WITH CTE1 AS (
  SELECT 
    CUSTOMERID, 
    STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE, 
    ROUND(QUANTITY * UNITPRICE, 0) AS REVENUE
  FROM RETAIL
  WHERE CUSTOMERID IS NOT NULL AND CUSTOMERID <> ''
),
CTE2 AS (
  SELECT 
    CUSTOMERID, 
    INVOICEDATE, 
    DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH,
    DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
    REVENUE
  FROM CTE1
),
CTE3 AS (
  SELECT 
    CUSTOMERID,
    FIRST_PURCHASE_MONTH AS Cohort,
    CONCAT(
      'Month_', 
      PERIOD_DIFF(
        EXTRACT(YEAR_MONTH FROM PURCHASE_MONTH),
        EXTRACT(YEAR_MONTH FROM FIRST_PURCHASE_MONTH)
      )
    ) AS COHORT_MONTH,
    REVENUE
  FROM CTE2
)
SELECT 
  Cohort,
  SUM(CASE WHEN COHORT_MONTH = 'Month_0' THEN REVENUE ELSE 0 END) AS Month_0,
  SUM(CASE WHEN COHORT_MONTH = 'Month_1' THEN REVENUE ELSE 0 END) AS Month_1,
  SUM(CASE WHEN COHORT_MONTH = 'Month_2' THEN REVENUE ELSE 0 END) AS Month_2,
  SUM(CASE WHEN COHORT_MONTH = 'Month_3' THEN REVENUE ELSE 0 END) AS Month_3,
  SUM(CASE WHEN COHORT_MONTH = 'Month_4' THEN REVENUE ELSE 0 END) AS Month_4,
  SUM(CASE WHEN COHORT_MONTH = 'Month_5' THEN REVENUE ELSE 0 END) AS Month_5,
  SUM(CASE WHEN COHORT_MONTH = 'Month_6' THEN REVENUE ELSE 0 END) AS Month_6,
  SUM(CASE WHEN COHORT_MONTH = 'Month_7' THEN REVENUE ELSE 0 END) AS Month_7,
  SUM(CASE WHEN COHORT_MONTH = 'Month_8' THEN REVENUE ELSE 0 END) AS Month_8,
  SUM(CASE WHEN COHORT_MONTH = 'Month_9' THEN REVENUE ELSE 0 END) AS Month_9,
  SUM(CASE WHEN COHORT_MONTH = 'Month_10' THEN REVENUE ELSE 0 END) AS Month_10,
  SUM(CASE WHEN COHORT_MONTH = 'Month_11' THEN REVENUE ELSE 0 END) AS Month_11,
  SUM(CASE WHEN COHORT_MONTH = 'Month_12' THEN REVENUE ELSE 0 END) AS Month_12
FROM CTE3
GROUP BY Cohort
ORDER BY Cohort;
```
# Usage Instructions
Import your retail data into the SALES.RETAIL table.

Run the exploration queries to verify data completeness.

Execute the cohort analysis queries to extract customer retention and revenue trends.

Use the results for further analysis or visualization in BI tools like Power BI, Tableau, or Excel.

# Possible Extensions
Calculate retention rates as a percentage of the original cohort.

Segment cohorts by geography, product categories, or customer demographics.

Expand analysis period beyond 12 months.

Automate monthly cohort reporting with dashboards.

