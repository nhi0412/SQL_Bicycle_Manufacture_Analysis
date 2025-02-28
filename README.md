# SQL_Bicycle_Manufacture_Analysis

##  **1. Introduction and Motivation**

The AdventureWorks2019 dataset, originally designed for SQL Server, provides a comprehensive representation of a fictional manufacturing and retail company, Adventure Works Cycles, which sells bicycles and cycling accessories.

By analyzing this dataset in Google BigQuery, a cloud-based data warehouse, we can leverage high-performance SQL queries to extract actionable business insights efficiently. This analysis allows us to explore key areas such as sales trends, customer behavior, inventory management, and financial performance.

## **2. The Goal of the Project**

Through this analysis, we focus on key business metrics such as sales trends, customer retention, inventory levels, and regional performance. Our objectives include:

- Sales Performance Analysis
- Growth Trends (YoY) growth rates
- Regional Sales Ranking
- Seasonal Discounts Impact
- Customer Retention (Cohort Analysis)
- Inventory Trends and Stock-to-Sales Ratio
- Pending Orders

## **3. Import Raw Data**

To access the AdventureWorks2019 eCommerce dataset in Google BigQuery's public datasets, follow these steps:

1. Sign in to your Google Cloud Platform (GCP) account and create a new project.
2. Open the BigQuery console and star the dataset for easy access.
3. In the console, enter the project name “adventureworks2019” and press Enter.
4. Navigate to the tables within the dataset.
5. Start writing SQL queries to analyze the data.

## **4. Read and Explain Dataset**

[AdventureWorks Data Dictionary](https://drive.google.com/file/d/1bwwsS3cRJYOg1cvNppc1K_8dQLELN16T/view)

Below is the business entities model highlights key tables related to customers, vendors, businesses, addresses, and contacts. It helps in understanding how different entities interact

![Image](https://github.com/user-attachments/assets/a03e53bd-dfc7-46e4-aa5e-4592e80e4084)

## 5. Exploring the Dataset
1. **Quantity of items, Sales value & Order quantity by each Subcategory in the last 12 months?**

```sql
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
```

| period | Name | qty_item | total_sales | order_cnt |
| --- | --- | --- | --- | --- |
| Sep 2013 | Bike Racks | 312 | 22828,51 | 71 |
| Sep 2013 | Bike Stands | 26 | 4134 | 26 |
| Sep 2013 | Bottles and Cages | 803 | 4676,56 | 380 |
| Sep 2013 | Bottom Brackets | 60 | 3118,14 | 19 |
| Sep 2013 | Brakes | 100 | 6390 | 29 |
| Sep 2013 | Caps | 440 | 2879,48 | 203 |
| Sep 2013 | Chains | 62 | 752,93 | 24 |
| Sep 2013 | Cleaners | 296 | 1611,83 | 108 |
| Sep 2013 | Cranksets | 75 | 13955,85 | 20 |
| Sep 2013 | Derailleurs | 97 | 5972,07 | 23 |
| Sep 2013 | Fenders | 169 | 3714,62 | 169 |
| Sep 2013 | Gloves | 444 | 7552,25 | 146 |
| Sep 2013 | Handlebars | 131 | 6486,59 | 47 |
| Sep 2013 | Helmets | 1016 | 27354,84 | 480 |
| Sep 2013 | Hydration Packs | 249 | 9186,16 | 87 |
| Sep 2013 | Jerseys | 1402 | 48318,09 | 304 |
| Sep 2013 | Locks | 1 | 15 | 1 |
| Sep 2013 | Mountain Bikes | 1194 | 1244716,84 | 263 |
| Sep 2013 | Mountain Frames | 662 | 224303,98 | 34 |
| Sep 2013 | Pedals | 438 | 16565,11 | 76 |
| Sep 2013 | Road Bikes | 1398 | 1318888,69 | 319 |
| Sep 2013 | Road Frames | 264 | 110277,04 | 38 |
| Sep 2013 | Saddles | 170 | 4250,05 | 39 |
| Sep 2013 | Shorts | 713 | 30568,71 | 130 |
| Sep 2013 | Socks | 430 | 2438,96 | 88 |
| Sep 2013 | Tights | 5 | 243,72 | 1 |
| Sep 2013 | Tires and Tubes | 1420 | 18561,39 | 787 |
| Sep 2013 | Touring Bikes | 1238 | 1214628,9 | 171 |
| Sep 2013 | Touring Frames | 337 | 154334,64 | 21 |
| Sep 2013 | Vests | 623 | 24100,47 | 102 |
| Sep 2013 | Wheels | 1 | 83,3 | 1 |
| Oct 2013 | Bike Racks | 284 | 21181,2 | 70 |
| Oct 2013 | Bike Stands | 24 | 3816 | 24 |
| Oct 2013 | Bottles and Cages | 845 | 5038,95 | 400 |
| Oct 2013 | Bottom Brackets | 132 | 7030,01 | 30 |
| Oct 2013 | Brakes | 142 | 9036,78 | 38 |
| Oct 2013 | Caps | 406 | 2738,84 | 208 |
| Oct 2013 | Chains | 93 | 1122,36 | 31 |
| Oct 2013 | Cleaners | 294 | 1612,76 | 108 |
| Oct 2013 | Cranksets | 118 | 19722,79 | 33 |
| Oct 2013 | Derailleurs | 135 | 8291,81 | 35 |
| Oct 2013 | Fenders | 170 | 3736,6 | 170 |
| Oct 2013 | Gloves | 447 | 7678,81 | 148 |
| Oct 2013 | Handlebars | 188 | 9196,1 | 56 |
| Oct 2013 | Helmets | 1127 | 30733,99 | 557 |
| Oct 2013 | Hydration Packs | 243 | 9207,61 | 86 |
| Oct 2013 | Jerseys | 1372 | 47761,26 | 324 |
| Oct 2013 | Mountain Bikes | 1231 | 1338738,67 | 305 |
| Oct 2013 | Mountain Frames | 632 | 221830,45 | 32 |

The sales data for September 2013 provides valuable insights into purchasing trends across various subcategories. Jerseys emerged as the top-performing category, generating the highest sales value of $48,318.09 and 304 orders, indicating strong demand for cycling apparel. Similarly, helmets recorded the highest quantity sold (1,016 units) with a significant sales value of $27,354.84, highlighting their importance in safety-conscious purchases. While bike racks and cranksets had fewer orders, their high sales values ($22,828.51 and $13,955.85, respectively) suggest they are high-ticket items. On the other hand, bottles and cages saw 803 units sold but only $4,676.56 in revenue, indicating they are low-cost, high-volume products. Accessories such as gloves ($7,552.25 in sales) and hydration packs ($9,186.16) also performed well, reflecting strong consumer interest in cycling gear. Overall, apparel, safety gear, and high-value components contributed significantly to sales, offering valuable insights for inventory management, pricing strategies, and targeted marketing efforts.

2. **What is the % YoY growth rate by SubCategory & release top 3 category with highest grow rate?**

```sql
WITH quantity_item
  AS (
    SELECT EXTRACT(year from a.ModifiedDate) AS year
          ,c.Name
          ,SUM(a.OrderQty) AS qty_item
    FROM `adventureworks2019.Sales.SalesOrderDetail` AS a
    LEFT JOIN `adventureworks2019.Production.Product` AS b on a.ProductID=b.ProductID
    LEFT JOIN `adventureworks2019.Production.ProductSubcategory` AS c on CAST(b.ProductSubcategoryID AS int)=c.ProductSubcategoryID
    GROUP BY year, name
    ORDER BY name, year),

previous_qty 
  AS (
    SELECT year
          ,Name
          ,qty_item
          ,LAG(qty_item) OVER(PARTITION BY Name ORDER BY year) AS prv_qty
    FROM quantity_item),

yoy 
  AS (
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
```

| **year** | **Name** | **qty_item** | **prv_qty** | **yoy_rate** | **ranking** |
| --- | --- | --- | --- | --- | --- |
| 2012 | Mountain Frames | 3168 | 510 | 5.21 | 1 |
| 2013 | Socks | 2724 | 523 | 4.21 | 2 |
| 2012 | Road Frames | 5564 | 1137 | 3.89 | 3 |

The Year-over-Year (YoY) growth analysis highlights the top three subcategories with the highest growth rates, showcasing significant demand increases. Mountain Frames experienced the most substantial growth, with a YoY rate of 5.21, increasing from 510 units in the previous year to 3,168 units in 2012, indicating a surge in popularity for mountain biking. Socks followed closely with a 4.21 growth rate, growing from 523 units to 2,724 units in 2013, reflecting rising interest in cycling apparel and accessories. Road Frames secured the third spot with a 3.89 YoY growth rate, increasing from 1,137 units to 5,564 units in 2012, emphasizing the strong demand for high-performance bike frames. 

These insights suggest a shift towards premium cycling equipment and accessories, which can inform future marketing strategies, inventory planning, and product promotions to capitalize on these high-growth segments.

3. **What is the top 3 TeritoryID with biggest Order quantity of every year?**

```sql
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
```

| **year** | **TerritoryID** | **order_qty** | **ranking** |
| --- | --- | --- | --- |
| 2014 | 4 | 11632 | 1 |
| 2014 | 1 | 8823 | 3 |
| 2014 | 6 | 9711 | 2 |
| 2013 | 4 | 26682 | 1 |
| 2013 | 6 | 22553 | 2 |
| 2013 | 1 | 17452 | 3 |
| 2012 | 1 | 8537 | 3 |
| 2012 | 4 | 17553 | 1 |
| 2012 | 6 | 14412 | 2 |
| 2011 | 4 | 3238 | 1 |
| 2011 | 6 | 2705 | 2 |
| 2011 | 1 | 1964 | 3 |

The territory-wise order analysis highlights the top three regions with the highest order quantities for each year, revealing consistent patterns in sales distribution. Territory 4 consistently ranked first from 2011 to 2014, with orders peaking at 26,682 in 2013, indicating it as the dominant sales region. Territory 6 maintained a second-place ranking across all years, with a notable increase in orders from 2,705 in 2011 to 22,553 in 2013, reflecting strong market growth. Territory 1 consistently ranked third, with a steady rise in order volume, nearly doubling from 8,537 in 2012 to 17,452 in 2013, before slightly declining to 8,823 in 2014. These insights suggest that Territories 4 and 6 are key revenue drivers, and their sustained growth presents opportunities for targeted marketing, regional promotions, and logistics optimization to further boost sales.

4. **What is the Total Discount Cost belongs to Seasonal Discount for each SubCategory?**

```sql
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
```

| **year** | **Name** | **total_discount** |
| --- | --- | --- |
| 2012 | Helmets | 827.64732 |
| 2013 | Helmets | 1606.041 |

The analysis of total discount costs under Seasonal Discounts for each subcategory reveals a significant increase in discount allocations for Helmets over time. In 2012, the total discount cost for helmets was $827.65, which nearly doubled to $1,606.04 in 2013. This increase suggests a strategic pricing approach, possibly to boost sales, clear inventory, or respond to competitive market conditions. The rising discount allocation may also indicate a growing demand for helmets, prompting promotional efforts to attract more customers. These insights can help in optimizing future discount strategies, pricing models, and sales forecasting to maximize profitability while maintaining customer engagement.

5. **What is the retention rate of customers in 2014 with the status of Successfully Shipped (Cohort Analysis)?**

```sql
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
```

| **mth_join** | **mth_diff** | **customer_cnt** |
| --- | --- | --- |
| 1 | M - 0 | 2076 |
| 1 | M - 2 | 89 |
| 1 | M - 5 | 61 |
| 1 | M - 3 | 252 |
| 1 | M - 4 | 96 |
| 1 | M - 1 | 78 |
| 1 | M - 6 | 18 |
| 2 | M - 1 | 51 |
| 2 | M - 4 | 58 |
| 2 | M - 0 | 1805 |
| 2 | M - 2 | 61 |
| 2 | M - 5 | 8 |
| 2 | M - 3 | 234 |
| 3 | M - 4 | 11 |
| 3 | M - 0 | 1918 |
| 3 | M - 3 | 44 |
| 3 | M - 1 | 43 |
| 3 | M - 2 | 58 |
| 4 | M - 0 | 1906 |
| 4 | M - 2 | 44 |
| 4 | M - 3 | 7 |
| 4 | M - 1 | 34 |
| 5 | M - 1 | 40 |
| 5 | M - 0 | 1947 |
| 5 | M - 2 | 7 |
| 6 | M - 0 | 909 |
| 6 | M - 1 | 10 |
| 7 | M - 0 | 148 |

The customer retention analysis for 2014 (based on Successfully Shipped orders) provides insights into how well customers continue to engage with the platform over time. Each mth_join represents the month customers first made a purchase, and mth_diff tracks how many of them returned in subsequent months.

- Initial Engagement: The highest number of new customers joined in January (2,076), February (1,805), March (1,918), April (1,906), and May (1,947), indicating strong acquisition in the first half of the year. However, this number dropped significantly in June (909) and July (148).
- Retention Trends: As months progress, the number of returning customers decreases. For instance, from January’s cohort, only 252 customers returned in Month 3, 96 in Month 4, and 18 in Month 6, showing a steady decline in engagement.
- Drop-Off Rates: The number of returning customers sharply drops after the initial months. For example, in February, 1,805 customers joined, but only 234 returned in Month 3, 58 in Month 4, and 8 in Month 5, suggesting a need for improved retention strategies.

Overall, the retention rate declines over time, highlighting potential gaps in customer engagement and loyalty. Strategies such as personalized marketing, loyalty programs, and post-purchase follow-ups could help improve long-term retention and increase repeat purchases.

6. **What is the trend of stock level & MoM diff % by all product in 2011?**

```sql
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
```

| Name | month | yr | stock_qty | stock_prv | diff |
| --- | --- | --- | --- | --- | --- |
| BB Ball Bearing | 6 | 2011 | 5259 |  | 0 |
| BB Ball Bearing | 7 | 2011 | 12837 | 5259 | 144,1 |
| BB Ball Bearing | 8 | 2011 | 9666 | 12837 | -24,7 |
| BB Ball Bearing | 9 | 2011 | 8845 | 9666 | -8,5 |
| BB Ball Bearing | 10 | 2011 | 19175 | 8845 | 116,8 |
| BB Ball Bearing | 11 | 2011 | 14544 | 19175 | -24,2 |
| BB Ball Bearing | 12 | 2011 | 8475 | 14544 | -41,7 |
| Blade | 6 | 2011 | 1280 |  | 0 |
| Blade | 7 | 2011 | 3166 | 1280 | 147,3 |
| Blade | 8 | 2011 | 2382 | 3166 | -24,8 |
| Blade | 9 | 2011 | 2122 | 2382 | -10,9 |
| Blade | 10 | 2011 | 4670 | 2122 | 120,1 |
| Blade | 11 | 2011 | 3598 | 4670 | -23 |
| Blade | 12 | 2011 | 1842 | 3598 | -48,8 |
| Chain Stays | 6 | 2011 | 1280 |  | 0 |
| Chain Stays | 7 | 2011 | 3166 | 1280 | 147,3 |
| Chain Stays | 8 | 2011 | 2341 | 3166 | -26,1 |
| Chain Stays | 9 | 2011 | 2122 | 2341 | -9,4 |
| Chain Stays | 10 | 2011 | 4670 | 2122 | 120,1 |
| Chain Stays | 11 | 2011 | 3598 | 4670 | -23 |
| Chain Stays | 12 | 2011 | 1842 | 3598 | -48,8 |
| Down Tube | 6 | 2011 | 640 |  | 0 |
| Down Tube | 7 | 2011 | 1541 | 640 | 140,8 |
| Down Tube | 8 | 2011 | 1191 | 1541 | -22,7 |
| Down Tube | 9 | 2011 | 1061 | 1191 | -10,9 |
| Down Tube | 10 | 2011 | 2335 | 1061 | 120,1 |
| Down Tube | 11 | 2011 | 1799 | 2335 | -23 |
| Down Tube | 12 | 2011 | 921 | 1799 | -48,8 |
| Fork Crown | 6 | 2011 | 640 |  | 0 |

The stock level trends in 2011 show sharp fluctuations, with major restocks in July and October (e.g., BB Ball Bearing +144.1% in July, +116.8% in October) followed by steep declines in August, November, and December (-24.7%, -24.2%, -41.7%). Similar patterns appear across products like Blade and Down Tube, indicating irregular demand cycles and possible supply chain inefficiencies. These insights highlight the need for better inventory forecasting and management to balance supply and demand effectively.

7. **What is the ratio of stock/sales in 2011 by product name, by month?**

```sql
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
```

| month | yr | ProductID | Name | sales | stock | ratio |
| --- | --- | --- | --- | --- | --- | --- |
| 12 | 2011 | 758 | Road-450 Red, 52 | 444 | 9926 | 22,4 |
| 12 | 2011 | 754 | Road-450 Red, 58 | 348 | 6984 | 20,1 |
| 12 | 2011 | 726 | LL Road Frame - Red, 48 | 625 | 10224 | 16,4 |
| 12 | 2011 | 729 | LL Road Frame - Red, 60 | 1040 | 16105 | 15,5 |
| 12 | 2011 | 755 | Road-450 Red, 60 | 216 | 3150 | 14,6 |
| 12 | 2011 | 757 | Road-450 Red, 48 | 54 | 780 | 14,4 |
| 12 | 2011 | 760 | Road-650 Red, 60 | 2449 | 33285 | 13,6 |
| 12 | 2011 | 763 | Road-650 Red, 48 | 3267 | 39585 | 12,1 |
| 12 | 2011 | 725 | LL Road Frame - Red, 44 | 1368 | 16210 | 11,8 |
| 12 | 2011 | 730 | LL Road Frame - Red, 62 | 889 | 10340 | 11,6 |
| 12 | 2011 | 762 | Road-650 Red, 44 | 3690 | 38250 | 10,4 |
| 12 | 2011 | 756 | Road-450 Red, 44 | 276 | 2752 | 10 |
| 12 | 2011 | 745 | HL Mountain Frame - Black, 48 | 76 | 747 | 9,8 |
| 12 | 2011 | 765 | Road-650 Black, 58 | 3666 | 33588 | 9,2 |
| 12 | 2011 | 743 | HL Mountain Frame - Black, 42 | 485 | 4470 | 9,2 |
| 12 | 2011 | 761 | Road-650 Red, 62 | 3131 | 28335 | 9 |
| 12 | 2011 | 766 | Road-650 Black, 60 | 2068 | 18649 | 9 |
| 12 | 2011 | 748 | HL Mountain Frame - Silver, 38 | 958 | 8474 | 8,8 |
| 12 | 2011 | 768 | Road-650 Black, 44 | 1539 | 12960 | 8,4 |
| 12 | 2011 | 722 | LL Road Frame - Black, 58 | 1404 | 11085 | 7,9 |
| 12 | 2011 | 764 | Road-650 Red, 52 | 1840 | 14443 | 7,8 |
| 12 | 2011 | 776 | Mountain-100 Black, 42 | 1224 | 9450 | 7,7 |
| 12 | 2011 | 732 | ML Road Frame - Red, 48 | 210 | 1624 | 7,7 |
| 12 | 2011 | 770 | Road-650 Black, 52 | 5616 | 42902 | 7,6 |
| 12 | 2011 | 772 | Mountain-100 Silver, 42 | 900 | 6501 | 7,2 |
| 12 | 2011 | 771 | Mountain-100 Silver, 38 | 1749 | 12141 | 6,9 |
| 12 | 2011 | 738 | LL Road Frame - Black, 52 | 3740 | 25900 | 6,9 |
| 12 | 2011 | 769 | Road-650 Black, 48 | 684 | 4501 | 6,6 |
| 12 | 2011 | 747 | HL Mountain Frame - Black, 38 | 1401 | 8626 | 6,2 |
| 12 | 2011 | 777 | Mountain-100 Black, 44 | 1827 | 9464 | 5,2 |
| 12 | 2011 | 767 | Road-650 Black, 62 | 810 | 3852 | 4,8 |
| 12 | 2011 | 741 | HL Mountain Frame - Silver, 48 | 285 | 1356 | 4,8 |
| 12 | 2011 | 742 | HL Mountain Frame - Silver, 46 | 1236 | 5722 | 4,6 |
| 12 | 2011 | 774 | Mountain-100 Silver, 48 | 990 | 4545 | 4,6 |
| 12 | 2011 | 775 | Mountain-100 Black, 38 | 1288 | 5440 | 4,2 |
| 12 | 2011 | 759 | Road-650 Red, 58 | 1032 | 4319 | 4,2 |
| 12 | 2011 | 773 | Mountain-100 Silver, 44 | 1728 | 6600 | 3,8 |
| 12 | 2011 | 778 | Mountain-100 Black, 48 | 1600 | 6150 | 3,8 |
| 12 | 2011 | 753 | Road-150 Red, 56 | 9947 | 27846 | 2,8 |
| 12 | 2011 | 749 | Road-150 Red, 62 | 9855 | 22800 | 2,3 |
| 12 | 2011 | 751 | Road-150 Red, 48 | 7264 | 14297 | 2 |
| 12 | 2011 | 752 | Road-150 Red, 52 | 6592 | 12366 | 1,9 |
| 12 | 2011 | 750 | Road-150 Red, 44 | 5150 | 9614 | 1,9 |
| 11 | 2011 | 760 | Road-650 Red, 60 | 316 | 8876 | 28,1 |
| 11 | 2011 | 770 | Road-650 Black, 52 | 432 | 9032 | 20,9 |
| 11 | 2011 | 765 | Road-650 Black, 58 | 376 | 7464 | 19,9 |
| 11 | 2011 | 763 | Road-650 Red, 48 | 297 | 5655 | 19 |
| 11 | 2011 | 761 | Road-650 Red, 62 | 101 | 1889 | 18,7 |
| 11 | 2011 | 764 | Road-650 Red, 52 | 80 | 1111 | 13,9 |
| 11 | 2011 | 768 | Road-650 Black, 44 | 324 | 4320 | 13,3 |
| 11 | 2011 | 776 | Mountain-100 Black, 42 | 255 | 3150 | 12,4 |
| 11 | 2011 | 771 | Mountain-100 Silver, 38 | 212 | 2556 | 12,1 |
| 11 | 2011 | 775 | Mountain-100 Black, 38 | 448 | 5440 | 12,1 |
| 11 | 2011 | 772 | Mountain-100 Silver, 42 | 100 | 1182 | 11,8 |
| 11 | 2011 | 766 | Road-650 Black, 60 | 188 | 2194 | 11,7 |
| 11 | 2011 | 773 | Mountain-100 Silver, 44 | 324 | 3600 | 11,1 |
| 11 | 2011 | 777 | Mountain-100 Black, 44 | 504 | 5408 | 10,7 |
| 11 | 2011 | 778 | Mountain-100 Black, 48 | 320 | 3075 | 9,6 |
| 11 | 2011 | 769 | Road-650 Black, 48 | 76 | 643 | 8,5 |
| 11 | 2011 | 767 | Road-650 Black, 62 | 81 | 642 | 7,9 |
| 11 | 2011 | 759 | Road-650 Red, 58 | 172 | 1234 | 7,2 |
| 11 | 2011 | 753 | Road-150 Red, 56 | 6293 | 20553 | 3,3 |
| 11 | 2011 | 749 | Road-150 Red, 62 | 7665 | 21000 | 2,7 |
| 11 | 2011 | 751 | Road-150 Red, 48 | 9080 | 19720 | 2,2 |
| 11 | 2011 | 752 | Road-150 Red, 52 | 5150 | 11450 | 2,2 |
| 11 | 2011 | 750 | Road-150 Red, 44 | 7004 | 14858 | 2,1 |
| 10 | 2011 | 758 | Road-450 Red, 52 | 1884 | 38995 | 20,7 |
| 10 | 2011 | 733 | ML Road Frame - Red, 52 | 546 | 11116 | 20,4 |
| 10 | 2011 | 754 | Road-450 Red, 58 | 1644 | 27936 | 17 |
| 10 | 2011 | 729 | LL Road Frame - Red, 60 | 7280 | 115956 | 15,9 |
| 10 | 2011 | 725 | LL Road Frame - Red, 44 | 7638 | 116712 | 15,3 |
| 10 | 2011 | 756 | Road-450 Red, 44 | 984 | 13072 | 13,3 |
| 10 | 2011 | 755 | Road-450 Red, 60 | 948 | 11900 | 12,6 |
| 10 | 2011 | 723 | LL Road Frame - Black, 60 | 101 | 1227 | 12,1 |
| 10 | 2011 | 730 | LL Road Frame - Red, 62 | 7874 | 82720 | 10,5 |
| 10 | 2011 | 760 | Road-650 Red, 60 | 12166 | 122045 | 10 |
| 10 | 2011 | 732 | ML Road Frame - Red, 48 | 1470 | 14616 | 9,9 |
| 10 | 2011 | 726 | LL Road Frame - Red, 48 | 7875 | 76680 | 9,7 |
| 10 | 2011 | 727 | LL Road Frame - Red, 52 | 376 | 3630 | 9,7 |
| 10 | 2011 | 757 | Road-450 Red, 48 | 387 | 3276 | 8,5 |
| 10 | 2011 | 762 | Road-650 Red, 44 | 14040 | 119250 | 8,5 |
| 10 | 2011 | 744 | HL Mountain Frame - Black, 44 | 414 | 3470 | 8,4 |
| 10 | 2011 | 770 | Road-650 Black, 52 | 15660 | 128706 | 8,2 |
| 10 | 2011 | 765 | Road-650 Black, 58 | 10998 | 87702 | 8 |
| 10 | 2011 | 763 | Road-650 Red, 48 | 11880 | 88595 | 7,5 |
| 10 | 2011 | 768 | Road-650 Black, 44 | 5508 | 38880 | 7,1 |

The stock-to-sales ratio in December 2011 for example varies significantly across products, indicating different levels of inventory management efficiency. The highest ratio is observed in Road-450 Red, 52 (22.4), meaning a large stock relative to sales, while Road-150 Red models have the lowest ratios (as low as 1.9), suggesting strong demand and quicker turnover. Products with ratios above 10 indicate potential overstocking, while those below 5 may require better stock replenishment strategies to meet demand efficiently.

8. **How many orders and value at Pending status in 2014?**

```sql
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
```

| **year** | **status** | **order_cnt** | **value** |
| --- | --- | --- | --- |
| 2014 | 1 | 224 | 9274512.9009 |

In 2014, there were 224 orders with a Pending status, totaling a value of $9,274,512.90. This indicates a significant amount of revenue tied up in pending transactions, which may require follow-ups or process optimizations to ensure timely fulfillment.

## **6. Conclusion**

- This project provided valuable exposure to the marketing landscape by analyzing customer interactions within an e-commerce platform using SQL in BigQuery.
- Through SQL queries, I examined critical metrics such as customer retention, order trends, stock levels, and revenue patterns to uncover key behavioral insights.
- Analyzing sales performance and inventory trends helped identify the most impactful factors influencing customer purchases and business efficiency.
- By utilizing optimized SQL queries, businesses can streamline operations, enhance decision-making, and allocate resources effectively to improve performance.
- BigQuery’s SQL capabilities enabled the extraction of meaningful insights, supporting data-driven strategies to optimize marketing efforts, improve customer engagement, and drive sustainable revenue growth.
