SELECT * FROM reductionanalysis;
SELECT * FROM ecommercedataset;

##Overall return rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM reductionanalysis;

## RETURN RATE BY PRODUCT CATEGORY
SELECT
    Product_Category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM reductionanalysis
GROUP BY Product_Category
ORDER BY return_rate_percent DESC;

##Return Rate by Supplier
SELECT
    Supplier_Name,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM reductionanalysis
GROUP BY Supplier_Name
ORDER BY return_rate_percent DESC;

##Return rate by Region
SELECT
    Region,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM reductionanalysis
GROUP BY Region
ORDER BY return_rate_percent DESC;

##Return Rate by Marketing Channel
SELECT
    Marketing_Channel,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM reductionanalysis
GROUP BY Marketing_Channel
ORDER BY return_rate_percent DESC;

##Return Rate by Return Reason (only returned items)
SELECT
    Return_Reason,
    COUNT(*) AS returned_orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecommercedataset WHERE Return_Date IS NOT NULL), 2) AS percent_of_returns
FROM ecommercedataset
WHERE Return_Date IS NOT NULL
GROUP BY Return_Reason
ORDER BY percent_of_returns DESC;

##Return Rate by Shipping Method
SELECT
    Shipping_Method,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM reductionanalysis
GROUP BY Shipping_Method
ORDER BY return_rate_percent DESC;

##Return rate by Payment method
SELECT
    Payment_Method,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(SUM(CASE WHEN Return_Date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM reductionanalysis
GROUP BY Payment_Method
ORDER BY return_rate_percent DESC;

##Return Rate by Discount
WITH bucketed_discount AS (
    SELECT
        CASE
            WHEN Discount_Applied >= 0 AND Discount_Applied < 10 THEN '0-10%'
            WHEN Discount_Applied >= 10 AND Discount_Applied < 20 THEN '10-20%'
            WHEN Discount_Applied >= 20 AND Discount_Applied < 30 THEN '20-30%'
            WHEN Discount_Applied >= 30 AND Discount_Applied < 50 THEN '30-50%'
            WHEN Discount_Applied >= 50 THEN '50%+'
            ELSE 'Unknown'
        END AS discount_bucket,
        CASE 
            WHEN Return_Date IS NOT NULL THEN 1
            ELSE 0
        END AS is_returned
    FROM reductionanalysis
)
SELECT
    discount_bucket,
    COUNT(*) AS total_orders,
    SUM(is_returned) AS returned_orders,
    ROUND(SUM(is_returned) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM bucketed_discount
GROUP BY discount_bucket
ORDER BY discount_bucket;


##Return Rate by Product Price
WITH bucketed_price AS (
    SELECT
        CASE
            WHEN Product_Price >= 0 AND Product_Price < 50 THEN '0-50'
            WHEN Product_Price >= 50 AND Product_Price < 100 THEN '50-100'
            WHEN Product_Price >= 100 AND Product_Price < 200 THEN '100-200'
            WHEN Product_Price >= 200 AND Product_Price < 500 THEN '200-500'
            WHEN Product_Price >= 500 THEN '500+'
            ELSE 'Unknown'
        END AS price_bucket,
        CASE 
            WHEN Return_Date IS NOT NULL THEN 1
            ELSE 0
        END AS is_returned
    FROM reductionanalysis
)
SELECT
    price_bucket,
    COUNT(*) AS total_orders,
    SUM(is_returned) AS returned_orders,
    ROUND(SUM(is_returned) * 100.0 / COUNT(*), 2) AS return_rate_percent
FROM bucketed_price
GROUP BY price_bucket
ORDER BY price_bucket;




