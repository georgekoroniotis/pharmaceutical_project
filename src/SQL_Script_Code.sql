-- Explore the tables

SELECT * FROM dbo.Geography;   -- 70 rows
SELECT * FROM dbo.Product;  -- 98 rows
SELECT * FROM dbo.SalesUnit; -- 2445 rows

SELECT * FROM dbo.Product where PRICE >100;


-- GEOGRAPHY
SELECT AREA, AREANAME, COUNT(0) AS CNT FROM dbo.Geography GROUP BY AREA, AREANAME ORDER BY 3 DESC;

-- PRODUCT
SELECT DISTINCT MOLECULE FROM dbo.Product;

/*
MOLECULE
-----------
ATORVASTATIN
PITAVASTATIN
ROSUVASTATIN
SIMVASTATIN
*/

SELECT DISTINCT CLASSIFICATION FROM dbo.Product;

/*
CLASSIFICATION
-------------
GENERIC
ORIGINAL
*/

SELECT DISTINCT LAB_NAME FROM dbo.Product;

/*
LAB_NAME
---------
ASTRAZENECA
ELPEN
GAP
KOWA PHARMA
MEDICAL PHARMAQUAL
PFIZER
VIANEX
WINMEDICA
*/

SELECT DISTINCT DISTR_NAME FROM dbo.Product;

/*
DISTR_NAME
------------
ASTRAZENECA
BENNETT GROUP
ELPEN
GAP
PFIZER
PHARMASERVE
VIANEX
WINMEDICA
*/

SELECT PRODUCT_ID, COUNT(1) as CNT FROM dbo.Product GROUP BY PRODUCT_ID HAVING COUNT(1) > 1;
SELECT * FROM dbo.Product WHERE PRODUCT_ID = 34411;
SELECT * FROM dbo.Product ORDER BY PRODUCT_ID;

/* there are duplicated data. so we need to remove from all data the dublications. */
WITH cte_products AS (
	SELECT p.*, ROW_NUMBER() OVER(PARTITION BY PRODUCT_ID,
											   INTERNAL_CODE,
											   FULL_DESCRIPTION,
											   PRODUCT,
											   ATC_CLASS,
											   PRICE,
											   LAB_NAME,
											   DISTR_NAME,
											   CLASSIFICATION,
											   MOLECULE
									 ORDER BY PRODUCT_ID,
											   INTERNAL_CODE,
											   FULL_DESCRIPTION,
											   PRODUCT,
											   ATC_CLASS,
											   PRICE,
											   LAB_NAME,
											   DISTR_NAME,
											   CLASSIFICATION,
											   MOLECULE
											   ) AS RN
												
	FROM dbo.Product p 												
	)
	--SELECT * FROM cte_products;
	DELETE FROM cte_products 
	WHERE RN > 1;

	SELECT * FROM dbo.Product ORDER BY PRODUCT_ID;

	sp_help 'dbo.Product';

	-- CHANGE THE TYPE OF THE FIELDS
	ALTER TABLE dbo.Product ALTER SALES_DATEUMN PRODUCT_ID INTEGER;
	ALTER TABLE dbo.Product ALTER SALES_DATEUMN INTERNAL_CODE INTEGER;
	
	-- create the primary key
	CREATE CLUSTERED INDEX product_id_index1 ON dbo.Product (PRODUCT_ID);
	
	SELECT * FROM dbo.Product;

	

--- SALES UNIT
SELECT * FROM dbo.SalesUnit ORDER BY PRODUCT_ID, TERRITORY_ID;

sp_help 'dbo.SalesUnit';



SELECT PRODUCT_ID, TERRITORY_ID, SALES_DATE, SALES_UNIT
INTO dbo.SaleUnitNorm
FROM (
		SELECT PRODUCT_ID, TERRITORY_ID, 
		[Οκτ-17],[Νοε-17],[Δεκ-17],[Ιαν-18],[Φεβ-18],[Μαρ-18],[Απρ-18],[Μαϊ-18],[Ιουν-18],[Ιουλ-18],[Αυγ-18],[Σεπ-18],[Οκτ-18],[Νοε-18],[Δεκ-18],
	    [Ιαν-19],[Φεβ-19],[Μαρ-19],[Απρ-19],[Μαϊ-19],[Ιουν-19],[Ιουλ-19],[Αυγ-19],[Σεπ-19],[Οκτ-19],[Νοε-19],[Δεκ-19],[Ιαν-20],[Φεβ-20],[Μαρ-20]
		 FROM dbo.SalesUnit) su  
UNPIVOT
   (sales_unit FOR SALES_DATE IN   
      ([Οκτ-17],[Νοε-17],[Δεκ-17],[Ιαν-18],[Φεβ-18],[Μαρ-18],[Απρ-18],[Μαϊ-18],[Ιουν-18],[Ιουλ-18],[Αυγ-18],[Σεπ-18],[Οκτ-18],[Νοε-18],[Δεκ-18],[Ιαν-19],[Φεβ-19],[Μαρ-19],[Απρ-19],[Μαϊ-19],
      [Ιουν-19],[Ιουλ-19],[Αυγ-19],[Σεπ-19],[Οκτ-19],[Νοε-19],[Δεκ-19],[Ιαν-20],[Φεβ-20],[Μαρ-20]) )AS unpvt
;

GO  

EXEC tempdb.dbo.sp_help N'#TEST';

WITH cte_sales_unit AS (
SELECT PRODUCT_ID
, TERRITORY_ID
, SALES_DATE
, LEFT(SALES_DATE, charindex('-', SALES_DATE) - 1) AS SALES_MONTH
, CAST('20' + REPLACE(SUBSTRING(SALES_DATE,CHARINDEX('-',SALES_DATE),LEN(SALES_DATE)),'-','') AS INTEGER) AS SALES_YEAR
, SALES_UNIT
FROM dbo.SalesUnitNorm
)
SELECT PRODUCT_ID
, TERRITORY_ID
, SALES_DATE
, CASE WHEN SALES_MONTH = N'Ιαν' THEN 'January'  
	   WHEN SALES_MONTH = N'Φεβ' THEN 'February'
	   WHEN SALES_MONTH = N'Μαρ' THEN 'March'
	   WHEN SALES_MONTH = N'Απρ' THEN 'April'
	   WHEN SALES_MONTH = N'Μαϊ' THEN 'May'
	   WHEN SALES_MONTH = N'Ιουν' THEN 'June'
	   WHEN SALES_MONTH = N'Ιουλ' THEN 'July'
	   WHEN SALES_MONTH = N'Αυγ' THEN 'August'
	   WHEN SALES_MONTH = N'Σεπ' THEN 'September'
	   WHEN SALES_MONTH = N'Οκτ' THEN 'October'
	   WHEN SALES_MONTH = N'Νοε' THEN 'November'
	   WHEN SALES_MONTH = N'Δεκ' THEN 'December'
    END  AS SALES_MONTH
, SALES_YEAR
, CAST (ROUND(SALES_UNIT,0) AS INTEGER) AS SALES_UNIT
INTO dbo.SalesUnitNorm2
FROM cte_sales_unit;



SELECT * FROM dbo.SalesUnitNorm2 
WHERE SALES_UNIT < 0;

-- UPDATE SALES UNIT
UPDATE dbo.SalesUnitNorm2 SET SALES_UNIT = 0 WHERE SALES_UNIT < 0;  -- 27 RECORDS




SELECT p.PRODUCT,  sum(su.SALES_UNIT * p.PRICE) AS total_revenue 
from dbo.SalesUnitNorm2 su -- 73350
inner join dbo.Product p  on su.PRODUCT_ID= p.PRODUCT_ID
inner join dbo.Geography g on su.TERRITORY_ID = g.TERRCODE
GROUP BY  p.PRODUCT 
ORDER BY total_revenue desc
;

1.354.341
14.691.688

SELECT SUM(SALES_UNIT) FROM dbo.SalesUnitNorm2;	-- 33.499.288			
--delete FROM dbo.SalesUnitNorm2 where SALES_UNIT = 0;
select * from dbo.SalesUnitNorm2 where PRODUCT_ID = 60413 order by SALES_UNIT desc
;
							
select distinct AREA, AREANAME from dbo.Geography p;  --49							
d




/*
The Market definition is a group of products used in the same area as the client’s product. Hence will be direct competitors of the client’s product when it will be launched. 
The goal of the market definition is to identify products that are sufficiently close substitutes in demand, so that you can measure the performance of client product compared to others.
*/

 
SELECT P.MOLECULE, p.PRODUCT, SUM(su.SALES_UNIT) as total_unit, ROUND(SUM(su.SALES_UNIT * p.PRICE),2) as total_revenue
from dbo.SalesUnitNorm2 su -- 73350
inner join dbo.Product p  on su.PRODUCT_ID= p.PRODUCT_ID
inner join dbo.Geography g on su.TERRITORY_ID = g.TERRCODE
WHERE su.SALES_MONTH = 'February' AND su.SALES_YEAR = 2018
GROUP BY P.MOLECULE, p.PRODUCT 
ORDER BY total_revenue desc
;


select * from dbo.SalesUnitNorm3 T1 
INNER JOIN dbo.Product T2 ON T1.PRODUCT_ID = T2.PRODUCT_ID
WHERE T2.PRODUCT = 'PLATOREL' AND T1.PRODUCT_ID <> 96024
ORDER BY SALES_DATE
;

SELECT * FROM dbo.Product WHERE PRODUCT = 'PLATOREL';

SELECT * FROM dbo.Product where PRICE = 0;


SELECT PRODUCT_ID
,TERRITORY_ID
,CAST( STR(SALES_YEAR) +'-'+ RIGHT('00'+ DATEPART(MM,SALES_MONTH +' 1 2014'),2) + '-01'AS DATE) AS SALES_DATE
,SALES_MONTH
,SALES_YEAR
,SALES_UNIT
INTO dbo.SalesUnitNorm3
FROM dbo.SalesUnitNorm2;


WITH MARKET_AREAS AS (
	SELECT DISTINCT T3.TERRCODE, T3.TERRNAME
	  FROM dbo.SalesUnitNorm3 T1 
	  INNER JOIN dbo.Product T2 ON T1.PRODUCT_ID = T2.PRODUCT_ID
	  INNER JOIN DBO.Geography T3 ON T1.TERRITORY_ID = T3.TERRCODE
	  WHERE T2.PRODUCT = 'PLATOREL' 
	  )


SELECT DISTINCT TERRCODE, TERRNAME FROM DBO.Geography ;


select ISNULL(T3.AREANAME,'--TOTAL--') AS AREANEAME, ISNULL(T2.PRODUCT,'--TOTAL--') AS PRODUCT, SUM(T1.SALES_UNIT) AS TOTAL_SOLD_UNITS
from dbo.SalesUnitNorm3 T1 
INNER JOIN dbo.Product T2 ON T1.PRODUCT_ID = T2.PRODUCT_ID
INNER JOIN DBO.Geography T3 ON T1.TERRITORY_ID = T3.TERRCODE
WHERE 1=1
AND T1.SALES_DATE >= '2018-02-01' 
--AND T2.PRODUCT = 'PLATOREL' 
GROUP BY ROLLUP (T3.AREANAME, T2.PRODUCT)
ORDER BY T3.AREANAME, TOTAL_SOLD_UNITS DESC 
;

SELECT * FROM dbo.SalesUnitNorm3 where SALES_DATE >= '2018-05-01';  -- 33499288




/*
The Market share represents the % ratio of a product Sales to the total market sales 
(sales of client product plus all the competitor product in the same disease area). 
The formula is: (Product / Total Market *100).
*/

with revenue as (
select su.*, su.SALES_UNIT * p.PRICE as revenue 
from dbo.SalesUnitNorm3 su inner join dbo.Product p on su.PRODUCT_ID = p.PRODUCT_ID
where SALES_DATE >= '2018-02-01'
), totals as (
select round(sum(revenue),2) as total_revenue
, sum(SALES_UNIT) AS TOTAL_UNITS
from revenue
)
, totals_by_area as(
	select g.AREA
	, g.AREANAME
	, round(sum(revenue),2) as total_revenue_by_area
	, sum(SALES_UNIT) AS TOTAL_UNITS_by_area
	from revenue r inner join Geography g on r.TERRITORY_ID = g.TERRCODE
	group by g.AREA, g.AREANAME
	)
SELECT G.AREANAME, P.PRODUCT
, ROUND(SUM((r.revenue / t.total_revenue_by_area) * 100),2) as MARKET_SHARE_BY_AREA  
, ROUND(SUM((r.revenue / l.total_revenue) * 100),2) as MARKET_SHARE
--INTO MARKET_SHARE
FROM revenue r
INNER JOIN Product p on r.PRODUCT_ID = p.PRODUCT_ID
INNER JOIN Geography G ON R.TERRITORY_ID = G.TERRCODE
inner join totals_by_area t on t.AREA = g.AREA
inner join totals l on 1=1
--WHERE p.PRODUCT = 'PLATOREL'
GROUP BY G.AREANAME,p.PRODUCT
ORDER BY G.AREANAME,p.PRODUCT	


/*
The Evolution Index represent the Product growth vs Market Growth. 
The formula is: ((100 + Product Growth%) / (100 + Market Growth%)) x 100.
*/

WITH PRODUCT_GROWTH AS (
SELECT 
   PRODUCT
,  SALES_DATE
, SUM(SALES_UNIT*P.PRICE) AS SALES 
, LAG (SUM(SALES_UNIT*P.PRICE)) OVER (PARTITION BY PRODUCT
                                          ORDER BY SALES_DATE) AS PREVIOUS_MONTH_SALES
FROM SalesUnitNorm3 su inner join Product p on su.PRODUCT_ID = p.PRODUCT_ID
WHERE SALES_DATE >= '2018-02-01'
GROUP BY   
  SALES_DATE
, PRODUCT
)
, MARKET_GROWTH AS (
 SELECT 
  SALES_DATE
, SUM(SALES_UNIT*P.PRICE) AS SALES
, LAG (SUM(SALES_UNIT*P.PRICE)) OVER (ORDER BY SALES_DATE) AS PREVIOUS_MONTH_SALES
FROM SalesUnitNorm3 su inner join Product p on su.PRODUCT_ID = p.PRODUCT_ID
WHERE SALES_DATE >= '2018-02-01'
GROUP BY   
  SALES_DATE
  )
  , MARKET_GROWTH_PERC AS (
SELECT * 
, 100.0 * (SALES - PREVIOUS_MONTH_SALES) / PREVIOUS_MONTH_SALES AS MARKET_GROWTH
FROM MARKET_GROWTH
--ORDER BY SALES_DATE
)
, PRODUCT_GROWTH_PERC AS (
SELECT * 
, 100.0 * (SALES - PREVIOUS_MONTH_SALES) / PREVIOUS_MONTH_SALES AS PRODCUCT_GROWTH
FROM PRODUCT_GROWTH
--ORDER BY PRODUCT, SALES_DATE
)
, EVOLUTION_INDEX AS (
SELECT PGP.PRODUCT, PGP.SALES_DATE, ((100.0 + PGP.PRODCUCT_GROWTH) / (100.0 + MGP.MARKET_GROWTH)) * 100.0 AS EVOLUTION_INDEX
FROM PRODUCT_GROWTH_PERC PGP 
INNER JOIN MARKET_GROWTH_PERC MGP 
ON PGP.SALES_DATE = MGP.SALES_DATE
)
SELECT * 
INTO EVOLUTION_INDEX_SALES
FROM EVOLUTION_INDEX
--WHERE PRODUCT = 'PLATOREL'
;

/*
COMPARING 
*/


SELECT * FROM PRODUCT WHERE PRODUCT IN ('CRESTOR', 'PLATOREL');

select * from dbo.SalesUnitNorm3;