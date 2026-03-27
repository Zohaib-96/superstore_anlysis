-- Load dataset & Prerequisite
CREATE DATABASE superstore;
use superstore;

select * from superstore_orders;

DESCRIBE superstore_orders;

select 
	count(*) as row_count,
    count(`Order ID`) as id_count
from superstore_orders;

-- change columns names 
ALTER TABLE superstore_orders
CHANGE `Row ID` row_id INT(50),
CHANGE `Order ID` order_id VARCHAR(50),
CHANGE `Ship Date` ship_date_raw TEXT,
CHANGE `Order Date` order_date_raw TEXT,
CHANGE `Ship Mode` ship_mode TEXT,
CHANGE `Customer ID` customer_id VARCHAR(50),
CHANGE `Customer Name` customer_name TEXT,
CHANGE `Postal Code` postal_code TEXT,
CHANGE `Product ID` product_id VARCHAR(50),
CHANGE `Sub-Category` sub_category VARCHAR(50),
CHANGE `Product Name` product_name TEXT;


select 
	order_date_raw,
    ship_date_raw
from superstore_orders
limit 10;

Alter table superstore_orders
drop column ship_date_raw,
drop column ship_date_raw;

-- first and last order date
select 
	min(order_date_raw) as first_date,
	max(order_date_raw) as last_date
from superstore_orders;

	
-- add column order_date & ship_date 
ALTER TABLE superstore_orders
ADD COLUMN order_date date,
ADD COLUMN ship_date date;

UPDATE superstore_orders
SET order_date = STR_TO_DATE(order_date_raw, '%m/%d/%Y'),
	ship_date = STR_TO_DATE(ship_date_raw, '%m/%d/%Y');

-- make ROW ID primary key
ALTER TABLE superstore_orders
ADD primary key (row_id);
DESCRIBE superstore_orders;

-- Check distinct values
select 
	Count(*),			
    COUNT(DISTINCT order_id)			as total_orders,
	COUNT(DISTINCT customer_id)			as total_customer,
    COUNT(DISTINCT product_id)			as total_products
from superstore_orders;

-- check Nulls
SELECT *
FROM superstore_orders
WHERE
    customer_id    IS NULL
    OR customer_name IS NULL
    OR city         IS NULL
    OR state        IS NULL
    OR region       IS NULL
    OR product_id   IS NULL
    OR product_name IS NULL
    OR category     IS NULL
    OR sub_category IS NULL
    OR order_date    IS NULL
    OR ship_date     IS NULL
    OR sales         IS NULL
    OR profit        IS NULL
LIMIT 100;

SELECT DISTINCT city          FROM superstore_orders ORDER BY city;
SELECT DISTINCT state         FROM superstore_orders ORDER BY state;
SELECT DISTINCT region        FROM superstore_orders ORDER BY region;
SELECT DISTINCT ship_mode     FROM superstore_orders ORDER BY ship_mode;
SELECT DISTINCT category      FROM superstore_orders ORDER BY category;
SELECT DISTINCT sub_category  FROM superstore_orders ORDER BY sub_category;
SELECT DISTINCT customer_name FROM superstore_orders ORDER BY customer_name;
SELECT DISTINCT Country  	  FROM superstore_orders ORDER BY Country;


-- see duplicate
select 
	order_id,
	product_id,
    sales,
    profit,
    count(*)		as _duplicate
from superstore_orders
group by 
	order_id,
	product_id,
    sales,
    profit
having count(*) > 1
order by _duplicate;
   
-- see duplicate
        
SELECT *
FROM superstore_orders
WHERE (order_id, product_id, sales, profit) IN (
    SELECT order_id, product_id, sales, profit
    FROM superstore_orders
    GROUP BY order_id, product_id, sales, profit
    HAVING COUNT(*) > 1
);

-- delete duplicate
delete d1
from superstore_orders d1
JOIN superstore_orders d2
where d1.order_id = d2.order_id
AND d1.product_id = d2.product_id
AND d1.sales = d2.sales
AND d1.profit = d2.profit
AND d1.row_id > d2.row_id;





#Basic
	-- 1 total sales and profit
	select 
		COUNT(*)		AS TOTAL,
		SUM(sales)		AS TOTAL_SALES,
		SUM(profit)		AS TOTAL_PROFIT
	FROM superstore_orders;

	-- 2: Total sales, profit, average order value(AVO), 
	select 
		Count(*)							AS total_items,
		count(distinct order_id)			as distinct_orders,
		ROUND(sum(sales),2)					as total_sales,
		ROUND(sum(profit),2)				as total_profit,
		ROUND(avg(sales),2)					as avg_sale,
		ROUND(sum(sales)/count(order_id),2)	as AVO,
		ROUND(sum(profit)/sum(sales),2)		as profit_margin
	from superstore_orders;

	 -- 3: How many orders per customer?
	SELECT
		customer_id,
		Count(order_id)	as num_orders,
		SUM(sales) AS total_spent,
		SUM(profit) AS total_profit
	FROM superstore_orders
	group by customer_id
	order by customer_id;

#Category & sub‑category performance

		-- 4: Which categories are driving sales and profit? 
	select 
		Category,
		COUNT(*) 							AS num_line_items,
		COUNT(DISTINCT order_id)			AS num_orders,
		ROUND(SUM(sales),2)					as sale,
		ROUND(sum(profit),2)				as profit,
		ROUND(AVG(sales),2)					AS avg_sales_per_item,
		ROUND(SUM(profit)/SUM(sales),2) 	AS profit_margin
	FROM superstore_orders
	group by Category
	order by sale;
	 
		-- 5: Sales and profit by sub_category (top 10)
	select 
		sub_category,
		Category,
		COUNT(DISTINCT order_id)			AS num_orders,
		COUNT(*) 							AS num_line_items,
		ROUND(SUM(sales),2)					as sale,
		ROUND(sum(profit),2)				as profit,
		ROUND(SUM(profit)/SUM(sales), 2)	as profit_margin
	FROM superstore_orders
	group by sub_category, Category
	order by sale DESC
	limit 10;

		-- 6: Find loss‑making sub‑categories
	select 
		sub_category,
		Category,
		COUNT(DISTINCT order_id)			AS num_orders,
		COUNT(*) 							AS num_line_items,
		ROUND(SUM(sales),2)					as sale,
		ROUND(sum(profit),2)				as profit,
		ROUND(SUM(profit)/SUM(sales), 2)	as profit_margin
	FROM superstore_orders
	group by sub_category, Category
	having profit < 0
	order by sale DESC;

#Geographic (region / state / city) analysis

		-- 7: where sales doing well or poorly (Sales & profit by region)
 select 
	region,
    count(*)							as num_line_items,
    count(distinct order_id)			as num_order,
    ROUND(SUM(sales),2)					as sales,
	ROUND(sum(profit),2)				as profit,
    ROUND(SUM(profit)/SUM(sales),2)		as profit_margin
 from superstore_orders
 group by region
 order by sales DESC;

		-- 8:Top 10 states by sales
 select 
	State,
    region,
    count(*)							as num_line_items,
    count(distinct order_id)			as num_order,
	ROUND(SUM(sales),2)					as sales,
	ROUND(sum(profit),2)				as profit,
    ROUND(SUM(profit)/SUM(sales),2)		as profit_margin
 from superstore_orders
 group by State, region
 order by sales Desc
 limit 10;

		-- 9:Top 10 cities by sales
SELECT
    city,
    state,
    region,
	ROUND(SUM(sales),2)		as sales,
	ROUND(sum(profit),2)	as profit
FROM superstore_orders
GROUP BY city, state, region
ORDER BY sales DESC
LIMIT 10;


 select * from superstore_orders limit 10;

 
#Customer‑level exploratory - Understand who your important customers are:
	-- 10: Top 10 customers by total spending & profit
 
SELECT 
	customer_id,
    customer_name,
    segment,
    region,
    COUNT(DISTINCT order_id) 			AS num_orders,
    ROUND(sum(sales),2)				as total_spend,
    ROUND(sum(profit),2)			as total_profit,
	ROUND(AVG(discount) * 100, 2)     AS avg_discount_pct
FROM superstore_orders
group by customer_id, customer_name, segment,region
order by total_spend Desc
limit 10;

	-- Bottom 10 customers by profit
SELECT 
	customer_id,
    customer_name,
    segment,
    region,
    COUNT(DISTINCT order_id) 			AS num_orders,
    ROUND(sum(sales),2)				as total_spend,
    ROUND(sum(profit),2)			as total_profit,
	ROUND(AVG(discount) * 100, 2)     AS avg_discount_pct
FROM superstore_orders
group by customer_id, customer_name, segment,region
order by total_spend Asc
limit 10;
 
 
#Time‑based exploratory year/month - Look at trends over time:
		-- 11: Orders, sales, profit by year
SELECT 
	YEAR(order_date)						as order_year,
    count(distinct order_id)				as num_order,
    ROUND(sum(sales),2)						as total_sales,
    ROUND(sum(profit),2)					as total_profit,
    ROUND(SUM(profit)/SUM(sales),2) 		as profit_margin
FROM superstore_orders
group by order_year
order by order_year;

		-- 12: Monthly sales & profit
SELECT 
	DATE_FORMAT(order_date, '%Y-%m')		as ym,
    ROUND(sum(sales),2)						as total_sale,
    ROUND(sum(profit),2)					as total_profit
FROM superstore_orders
GROUP BY ym
ORDER BY ym;
 
#Shipping & discount behavior, affect of shipmode and discount on sales/profit?
		-- 13: Sales & profit by ship_mode
SELECT 
	ship_mode,
    COUNT(*) 								AS num_order,
    ROUND(sum(sales),2)						as total_sale,
    ROUND(sum(profit),2)					as total_profit
FROM superstore_orders
group by ship_mode
order by total_sale Desc;

		-- 14: Orders by discount level
SELECT 
	CASE
		WHEN Discount = 0 THEN '0% discount'
		WHEN Discount BETWEEN 0 AND 0.1 THEN '0–10%'
		WHEN Discount BETWEEN 0.1 AND 0.2 THEN '10–20%'
		WHEN Discount BETWEEN 0.2 AND 0.3 THEN '20–30%'
        WHEN Discount > 0.3 THEN '>30%'
	END AS discount,
    COUNT(*)	AS num_order,
    ROUND(sum(sales),2)						as total_sale,
    ROUND(sum(profit),2)					as total_profit,
    ROUND(SUM(profit)/SUM(sales),2)			AS profit_margin
FROM superstore_orders
GROUP BY discount
ORDER BY discount;

 

 ------
 
use superstore;
select * from superstore_orders;

-- 15:summary scorecard
SELECT
    ROUND(SUM(sales), 2)                          AS total_revenue,
    ROUND(SUM(profit), 2)                         AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    COUNT(DISTINCT order_id)                       AS total_orders,
    COUNT(DISTINCT customer_id)                    AS total_customers,
    COUNT(DISTINCT product_id)                     AS total_products,
    ROUND(AVG(discount) * 100, 2)                  AS avg_discount_pct
FROM superstore_orders;

#:Which categories are truly profitable vs just high revenue?
	-- 16: Total sales, profit, margin by category
SELECT 
	Category,
	ROUND(SUM(sales), 2)                          AS total_sale,
    ROUND(SUM(profit), 2)                         AS total_profit,
	ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    Sum(Quantity)								  AS units_sold 
FROM superstore_orders
group by Category
order by total_profit DESC;


	-- 17: Sub-category ranked by profitability

SELECT 
	Category,
    sub_category,
	ROUND(SUM(sales), 2)                          AS total_sale,
    ROUND(SUM(profit), 2)                         AS total_profit,
	ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    Sum(Quantity)								  AS units_sold 
FROM superstore_orders
group by sub_category, Category
order by total_profit DESC;

	-- 18: Loss-making sub-categories
SELECT 
	Category,
    sub_category,
	ROUND(SUM(sales), 2)                          AS total_sale,
    ROUND(SUM(profit), 2)                         AS total_profit,
	ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    Sum(Quantity)								  AS units_sold 
FROM superstore_orders
group by sub_category, Category
having total_profit <= 0
order by total_profit DESC;

#Regional Performance
	-- 19: Sales and profit by region
    
SELECT 
	region,
	ROUND(SUM(sales), 2)                          AS total_sale,
    ROUND(SUM(profit), 2)                         AS total_profit,
	ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    Sum(Quantity)								  AS units_sold 
FROM superstore_orders
group by region
order by total_profit DESC;

	-- 20: Category performance WITHIN each region

SELECT 
	region,
    Category,
	ROUND(SUM(sales), 2)                          AS total_sale,
    ROUND(SUM(profit), 2)                         AS total_profit,
	ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    Sum(Quantity)								  AS units_sold 
FROM superstore_orders
group by region, Category
order by region, total_sale DESC;

	-- 21: Top 5 most profitable states
    
SELECT 
    State,
	ROUND(SUM(sales), 2)                          AS total_sale,
    ROUND(SUM(profit), 2)                         AS total_profit,
	ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    Sum(Quantity)								  AS units_sold 
FROM superstore_orders
group by State
order by total_profit DESC
limit 5;

	-- 22: Bottom 5 least profitable states
SELECT 
    State,
	ROUND(SUM(sales), 2)                          AS total_sale,
    ROUND(SUM(profit), 2)                         AS total_profit,
	ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    Sum(Quantity)								  AS units_sold 
FROM superstore_orders
group by State
order by total_profit ASC
limit 5;

#Customer Segment Analysis
-- 23: Sales, profit, avg discount by segment
SELECT
    segment,
    COUNT(DISTINCT customer_id)                  AS num_customers,
    COUNT(DISTINCT order_id)                     AS num_orders,
    ROUND(SUM(sales), 2)                         AS total_sales,
    ROUND(SUM(profit), 2)                        AS total_profit,
    ROUND(AVG(discount) * 100, 2)                AS avg_discount_pct,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)     AS profit_margin_pct
FROM superstore_orders
GROUP BY segment
ORDER BY total_profit DESC;

-- 24: which segment buys what?
SELECT
    segment,
    category,
    ROUND(SUM(sales), 2)    AS total_sales,
    ROUND(SUM(profit), 2)   AS total_profit,
    SUM(quantity)           AS units_sold
FROM superstore_orders
GROUP BY segment, category
ORDER BY segment, total_profit DESC;

#Date-Based Analysis
-- 25: Year-over-Year Growth Using
With yearly_sales AS (
	SELECT 
	Year(order_date)		AS order_year,
	ROUND(SUM(sales), 2)    AS total_sales,
    ROUND(SUM(profit), 2)   AS total_profit
    FROM superstore_orders
    Group by order_year
    order by order_year
) 
select
	order_year,
	total_sales,
    LAG(total_sales) OVER (order by order_year)		as pre_yr_sale,
    total_profit,
    ROUND(
    (total_sales) - LAG(total_sales) OVER(order by order_year) / LAG(total_sales) OVER (order by order_year) * 100 ,2)
    as yoy_growth_pct
From yearly_sales
order by order_year;

	-- 26: monthly sale trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m')             AS y_m,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(SUM(sales), 2)                         AS monthly_sales,
    ROUND(SUM(profit), 2)                        AS monthly_profit
FROM superstore_orders
GROUP BY y_m
ORDER BY y_m ASC;

	-- 27: month-over-month Growth Using
With monthly_sales AS (
	SELECT
    DATE_FORMAT(order_date, '%Y-%m') 	AS ym,
    ROUND(SUM(sales), 2)                         AS monthly_sales,
    ROUND(SUM(profit), 2)                        AS monthly_profit
    FROM superstore_orders
    group by ym
)
SELECT
	ym,
    monthly_sales							as current_month_sale,
    LAG(monthly_sales) OVER(order by ym)	as pre_month_sale,
    monthly_profit,
    ROUND(
	monthly_sales - LAG(monthly_sales) OVER(order by ym) /
	LAG(monthly_sales) OVER (ORDER BY ym) * 100, 2)
    as mom_growth_pct
FROM monthly_sales
order by ym;

	-- 28:Sales by Month Name
SELECT
	MONTH(order_date)                AS month_num,
	DATE_FORMAT(order_date, '%M')    AS month_name,
    COUNT(DISTINCT order_id)         AS total_orders,
	ROUND(SUM(sales), 2)             AS monthly_sales,
    ROUND(SUM(profit), 2)            AS monthly_profit
FROM superstore_orders
group by month_name, month_num
order by month_num;

	-- 29:Quarterly Seasonality
SELECT
	year(order_date)				AS order_year,
    CONCAT('Q', QUARTER(order_date))AS quarter_label,
    ROUND(SUM(sales), 2)            AS monthly_sales,
    ROUND(SUM(profit), 2)           AS monthly_profit,
    COUNT(DISTINCT order_id)        AS total_orders
FROM superstore_orders
group by order_year, quarter_label
order by order_year, quarter_label;

	-- 30: Calculate how many days it takes to ship each order,
SELECT
    ship_mode,
    ROUND(avg(datediff(ship_date, order_date)),0)	as avg_ship_days,
    min(datediff(ship_date, order_date))			as min_ship_days,
    max(datediff(ship_date, order_date))			as max_ship_days,
	COUNT(DISTINCT order_id)                        AS total_orders
FROM superstore_orders
group by ship_mode
order by avg_ship_days;

	-- 31: Calculate how many days it takes to ship each order
SELECT	
	CASE
	WHEN DATEDIFF(ship_date, order_date) =  0 	THEN 'SAME DAY' 
    WHEN DATEDIFF(ship_date, order_date) <= 2 	THEN '1-2 DAYS'
    WHEN DATEDIFF(ship_date, order_date) <= 4	THEN '3-4 DAYS'
    WHEN DATEDIFF(ship_date, order_date) <= 7	THEN '5-7 DAYS'
    ELSE 											 '7+ DAYS'
    END 										AS delivery_bucket,
	COUNT(DISTINCT order_id)                         AS num_orders,
    ROUND(SUM(sales), 2)                             AS total_sales,
    ROUND(SUM(profit), 2)                            AS total_profit
FROM superstore_orders
GROUP BY delivery_bucket
ORDER BY num_orders DESC;

	-- 32: Running Cumulative Sales (Running by monthly sale)
    
WITH monthly_sales AS (
	SELECT
    DATE_FORMAT(order_date, '%Y-%m') 	AS ym,
    ROUND(SUM(sales), 2)                AS monthly_sales
    FROM superstore_orders
    GROUP BY ym
)
	SELECT
    ym,
    monthly_sales,
    ROUND(
        SUM(monthly_sales) OVER (ORDER BY YM)
    , 2) AS running_total
    FROM monthly_sales;

-- 15:summary scorecard
SELECT
    ROUND(SUM(sales), 2)                          AS total_revenue,
    ROUND(SUM(profit), 2)                         AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    COUNT(DISTINCT order_id)                       AS total_orders,
    COUNT(DISTINCT customer_id)                    AS total_customers,
    COUNT(DISTINCT product_id)                     AS total_products,
    ROUND(AVG(discount) * 100, 2)                  AS avg_discount_pct
FROM superstore_orders;

	-- 33: How many customers ordered 1 order, 2 orders, 3 orders, etc.
SELECT
	total_orders,
    COUNT(customer_id)	num_customer
FROM(
	SELECT
		customer_id,
		COUNT(DISTINCT order_id) AS total_orders
	FROM superstore_orders
	GROUP BY customer_id
	)	AS order_counts
GROUP BY total_orders
ORDER BY total_orders ;
 
	-- 34: Average orders per customer by segment
SELECT 
	Segment,
    COUNT(distinct customer_id)		total_customer,
    COUNT(distinct order_id)		total_order,
	ROUND(COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_id), 2) AS avg_orders_per_customer
FROM superstore_orders
group by Segment
order by total_customer Desc;

	-- 35: RFM ( Recency, Frequency, Monetary)
    SELECT max(order_date) from superstore_orders; # '2017-12-30'

WITH rfm_base AS (    
	Select 
		customer_id,
		customer_name,
		max(order_date) as last_order_date,
		DATEDIFF('2017-12-31', MAX(order_date)) as recency_score,
		COUNT(DISTINCT order_id) AS frequency_score,
		ROUND(SUM(sales), 2) AS monetary_score
	From superstore_orders
	group by customer_id, customer_name
),
rfm_scored AS (
    Select
        customer_id,
        customer_name,
        last_order_date,
        recency_score,
        frequency_score,
        monetary_score,
        NTILE(5) OVER (ORDER BY recency_score DESC)    AS r_score,
        NTILE(5) OVER (ORDER BY frequency_score ASC)        AS f_score,
        NTILE(5) OVER (ORDER BY monetary_score ASC)         AS m_score
    From rfm_base
)
SELECT
    customer_id,
    customer_name,
    recency_score,
    frequency_score,
    monetary_score,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score)                         AS rfm_total_score,
   CASE
		WHEN (r_score + f_score + m_score) >= 13 THEN 'Champions'
		WHEN (r_score + f_score + m_score) >= 10 THEN 'Loyal Customers'
		WHEN (r_score + f_score + m_score) >= 7  THEN 'Potential Loyalists'
		WHEN (r_score + f_score + m_score) >= 4  THEN 'At Risk'
		ELSE 'Lost Customers'
	END
From rfm_scored
Order by rfm_total_score;



-- 36. How many customers do we have (unique customer IDs) in total and how much per region and state?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM superstore_orders;

-- A. region
SELECT region, COUNT(DISTINCT customer_id) AS total_customers
FROM superstore_orders
GROUP BY region
ORDER BY total_customers DESC;

-- B. Statewise
SELECT State, COUNT(DISTINCT customer_id) AS total_customers
FROM superstore_orders
GROUP BY State
ORDER BY total_customers DESC;


-- 37: VIEWS 
	-- View 1: Overall business KPIs
    
Create or Replace VIEW vw_business_kpis AS
	Select 
		COUNT(DISTINCT order_id)                         AS total_orders,
		COUNT(DISTINCT customer_id)                      AS total_customers,
		COUNT(DISTINCT product_id)                       AS total_products,
		ROUND(SUM(sales), 2)                             AS total_revenue,
		ROUND(SUM(profit), 2)                            AS total_profit,
		ROUND(SUM(profit) / SUM(sales) * 100, 2)         AS profit_margin_pct,
		ROUND(AVG(discount) * 100, 2)                    AS avg_discount_pct
    From superstore_orders;
    
Select * from vw_business_kpis;

	-- View 2: Category Performance
CREATE OR REPLACE VIEW vw_category_performance AS
	SELECT
		category,
		sub_category,
		ROUND(SUM(sales), 2)                             AS total_sales,
		ROUND(SUM(profit), 2)                            AS total_profit,
		ROUND(SUM(profit) / SUM(sales) * 100, 2)         AS profit_margin_pct,
		SUM(quantity)                                    AS units_sold
	FROM superstore_orders
	GROUP BY category, sub_category;

Select * from vw_category_performance;
    
	-- View 3: Regional performance
CREATE OR REPLACE VIEW vw_region_performance AS
	SELECT
		region,
		state,
		COUNT(DISTINCT order_id)                         AS total_orders,
		ROUND(SUM(sales), 2)                             AS total_sales,
		ROUND(SUM(profit), 2)                            AS total_profit,
		ROUND(SUM(profit) / SUM(sales) * 100, 2)         AS profit_margin_pct
	FROM superstore_orders
	GROUP BY region, state;
    
Select * from vw_region_performance;

	-- View 4: Monthly sales trend
CREATE OR REPLACE VIEW vw_monthly_trend AS
	SELECT
		DATE_FORMAT(order_date, '%Y-%m')                 AS ym,
		YEAR(order_date)                                 AS order_year,
		MONTH(order_date)                                AS order_month,
		COUNT(DISTINCT order_id)                         AS total_orders,
		ROUND(SUM(sales), 2)                             AS monthly_sales,
		ROUND(SUM(profit), 2)                            AS monthly_profit
	FROM superstore_orders
	GROUP BY ym, order_year, order_month;
 
Select * from vw_monthly_trend;
 
 
 -- 38: Stored Procedures
 
	-- Sale by Region
    
delimiter ;; 
CREATE procedure getSaleByRegion(IN p_region varchar(20))
Begin 
	Select 
		region,
        category,
        ROUND(SUM(sales), 2)                         AS total_sales,
        ROUND(SUM(profit), 2)                        AS total_profit,
        COUNT(DISTINCT order_id)                     AS total_orders
    FROM superstore_orders
    where region = p_region
    group by region, category
    order by total_profit Desc;
END ;;
delimiter ; 

call getSaleByRegion('West');
call getSaleByRegion('East');
call getSaleByRegion('West');
call getSaleByRegion('South');
    

 
 
 
 