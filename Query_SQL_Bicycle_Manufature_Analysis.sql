/*Q1: Quantity of items, Sales value & Order quantity by each Subcategory in the last 12 months?*/
WITH latestdate AS (
    SELECT MAX(ModifiedDate) AS max_date
    FROM `adventureworks2019.Sales.SalesOrderDetail`
),

cte AS (
    SELECT 
        a.*
        ,b.ProductSubcategoryID
        ,FORMAT_TIMESTAMP('%b %Y', a.ModifiedDate) AS period
    FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
    LEFT JOIN `adventureworks2019.Production.Product` AS b 
    ON a.ProductID = b.ProductID
    WHERE DATE(a.ModifiedDate) >= DATE_SUB((SELECT DATE(max_date) FROM latestdate), INTERVAL 12 MONTH)
)

SELECT DISTINCT 
    cte.period
    ,c.Name
    ,SUM(cte.OrderQty) AS qty_item
    ,ROUND(SUM(cte.LineTotal), 2) AS total_sales
    ,COUNT(DISTINCT cte.SalesOrderID) AS order_cnt
FROM cte
LEFT JOIN `adventureworks2019.Production.ProductSubcategory` AS c 
ON CAST(cte.ProductSubcategoryID AS int) = c.ProductSubcategoryID
GROUP BY cte.period, c.Name
ORDER BY cte.period DESC, c.Name;

/*Q2: What is the % YoY growth rate by SubCategory & release top 3 category with highest grow rate?*/
WITH quantity_item AS (
    SELECT EXTRACT(year from a.ModifiedDate) AS year
          ,c.Name
          ,SUM(a.OrderQty) AS qty_item
    FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
    LEFT JOIN `adventureworks2019.Production.Product` AS b on a.ProductID=b.ProductID
    LEFT JOIN `adventureworks2019.Production.ProductSubcategory` AS c on CAST(b.ProductSubcategoryID AS int)=c.ProductSubcategoryID
    GROUP BY year, name
    ORDER BY name, year),

previous_qty AS (
    SELECT year
          ,Name
          ,qty_item
          ,LAG(qty_item) OVER(PARTITION BY Name ORDER BY year) AS prv_qty
    FROM quantity_item),

yoy AS (
    SELECT year
          ,Name
          ,qty_item
          ,prv_qty
          ,ROUND((qty_item/prv_qty -1), 2) AS yoy_rate
    FROM previous_qty
    ORDER BY name, year)

SELECT *
FROM (
    SELECT year
          ,Name
          ,qty_item
          ,prv_qty
          ,yoy_rate
          ,DENSE_RANK() OVER(ORDER BY yoy_rate DESC) AS ranking
    FROM yoy
    WHERE yoy_rate IS NOT NULL
          AND yoy_rate >0
    ORDER BY ranking, yoy_rate DESC)
WHERE ranking<=3;

/*Q3: Ranking Top 3 TeritoryID with biggest Order quantity of every year*/
WITH cte 
  AS(
    SELECT EXTRACT(year from a.ModifiedDate) AS year
          ,TerritoryID
          ,SUM(OrderQty) AS order_qty
    FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
    JOIN `adventureworks2019.Sales.SalesOrderHeader` AS b
    ON a.SalesOrderID=b.SalesOrderID
    GROUP BY year, TerritoryID)

SELECT *
  FROM (
      SELECT year
            ,TerritoryID
            ,order_qty
            ,DENSE_RANK() OVER(PARTITION BY year ORDER BY order_qty DESC) AS ranking
      FROM cte
      ORDER BY year DESC)
WHERE ranking <=3;

/*Q4: What is the Total Discount Cost belongs to Seasonal Discount for each SubCategory?*/
SELECT EXTRACT(year from a.ModifiedDate) AS year
      ,c.Name
      ,SUM(d.DiscountPct* a.UnitPrice* a.OrderQty)  AS total_discount
FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
LEFT JOIN `adventureworks2019.Production.Product` AS b on a.ProductID=b.ProductID
LEFT JOIN `adventureworks2019.Production.ProductSubcategory` AS c on CAST(b.ProductSubcategoryID AS int)=c.ProductSubcategoryID
LEFT JOIN `adventureworks2019.Sales.SpecialOffer` AS d on a.SpecialOfferID=d.SpecialOfferID
WHERE lower(Type) like '%seasonal discount%' 
GROUP BY year, c.Name
ORDER BY c.Name, year;

/*Q5: Retention rate of Customer in 2014 with status of Successfully Shipped (Cohort Analysis)*/
WITH info AS (
SELECT EXTRACT(month from ModifiedDate) AS mth_order
      ,EXTRACT(year from ModifiedDate) AS yr
      ,CustomerID
      ,COUNT(DISTINCT SalesOrderId) AS sales_cnt
FROM `adventureworks2019.Sales.SalesOrderHeader`
WHERE Status = 5 
      AND EXTRACT(year from ModifiedDate) = 2014
GROUP BY mth_order, yr, CustomerID
),

row_num AS (
      SELECT *
            ,row_number() OVER(PARTITION BY CustomerID ORDER BY mth_order) AS row_nb
      From info
),

first_order AS (
      SELECT DISTINCT mth_order AS mth_join
            ,yr
            ,CustomerID
      FROM row_num
      WHERE row_nb =1
),

all_join AS (
SELECT DISTINCT a.mth_order
            ,a.yr
            ,a.CustomerID
            ,b.mth_join
            ,CONCAT('M - ', a.mth_order-b.mth_join) AS mth_diff
FROM info AS a
LEFT JOIN first_order AS b ON a.CustomerID= b.CustomerID
ORDER BY CustomerID
)

SELECT DISTINCT mth_join
      ,mth_diff
      ,COUNT(DISTINCT CustomerID) AS customer_cnt
FROM all_join
GROUP BY mth_join, mth_diff
ORDER BY mth_join;

/*Q6: Trend of Stock level & MoM diff % by all product in 2011*/
WITH cte AS (
  SELECT a.Name
        ,EXTRACT(MONTH FROM b.ModifiedDate) AS month
        ,EXTRACT(year FROM b.ModifiedDate) AS yr
        ,SUM(b.StockedQty) AS stock_qty
  FROM `adventureworks2019.Production.Product` AS a
  JOIN `adventureworks2019.Production.WorkOrder` AS b
  ON a.ProductID= b.ProductID
  WHERE EXTRACT(year FROM b.ModifiedDate) = 2011
  GROUP BY a.Name, month, yr
  ORDER BY a.Name, month
),
prv_stock AS (
  SELECT Name
        ,month
        ,yr
        ,stock_qty
        ,LAG(stock_qty) OVER(PARTITION BY Name ORDER BY month) AS stock_prv
  FROM cte
  ORDER BY Name, month
)

SELECT *
      ,COALESCE(ROUND((stock_qty/stock_prv -1)*100, 1), 0) AS diff
FROM prv_stock;

/*Q7: Calc Ratio of Stock / Sales in 2011 by product name, by month*/
SELECT EXTRACT(month FROM b.ModifiedDate) AS month
      ,EXTRACT(year FROM b.ModifiedDate) AS yr
      ,a.ProductID
      ,a.Name
      ,SUM(b.OrderQty) AS sales
      ,SUM(c.StockedQty) AS stock
      ,ROUND(SUM(c.StockedQty)/SUM(b.OrderQty), 1) AS ratio
FROM `adventureworks2019.Production.Product` AS a
JOIN `adventureworks2019.Sales.SalesOrderDetail` AS b ON a.ProductID=b.ProductID
JOIN `adventureworks2019.Production.WorkOrder` AS c ON a.ProductID=c.ProductID
WHERE EXTRACT(year FROM b.ModifiedDate) = 2011
GROUP BY month, yr, a.ProductID, a.Name
ORDER BY month DESC, ratio DESC;

/*Q8: No of order and value at Pending status in 2014*/
SELECT EXTRACT(year FROM a.ModifiedDate) AS year
      ,b.Status AS status
      ,COUNT(DISTINCT a.PurchaseOrderID) AS order_cnt
      ,SUM(TotalDue) as value
FROM `adventureworks2019.Purchasing.PurchaseOrderDetail` AS a
JOIN `adventureworks2019.Purchasing.PurchaseOrderHeader` AS b 
ON a.PurchaseOrderID=b.PurchaseOrderID
WHERE EXTRACT(year FROM a.ModifiedDate)= 2014
      AND b.Status= 1
GROUP BY year, status;