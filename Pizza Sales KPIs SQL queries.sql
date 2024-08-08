-- Creating Database
create database pizza_database;

-- Using Database
use pizza_database;

-- Creating Table 
create table pizza_sales(
pizza_id int,
order_id int,
pizza_name_id varchar(20),
quantity int,
order_date date,
order_time time,
unit_price decimal(5,2),
total_price decimal(5,2),	
pizza_size varchar(10),
pizza_category varchar(10),
pizza_ingredients	varchar(100),
pizza_name varchar(50)
);

-- Loading Data in Table from local folder
load data infile "F:/Data Analyst Project/Coffee_Sales/pizza_sales_1.csv"
into table pizza_sales
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

-- Querying Data
select * from pizza_sales limit 5;

-- PIZZA SALES SQL QUERIES
-- A. KPI’s

-- 1. Total Revenue:
select sum(total_price) from pizza_sales;

-- 2. Average Order Value
select sum(total_price)/count(distinct order_id) from pizza_sales;

-- 3. Total Pizzas Sold
select sum(quantity) from pizza_sales;

-- 4. Total Orders
select count(distinct order_id) from pizza_sales;

-- 5. Average Pizzas Per Order
select sum(quantity)/count(distinct order_id)  from pizza_sales;

-- B. Daily Trend for Total Orders
SELECT 
    DAYNAME(order_date),
--     WEEKDAY(order_date),
    COUNT(DISTINCT order_id)
FROM
    pizza_sales
GROUP BY DAYNAME(order_date), WEEKDAY(order_date) 
ORDER BY count(distinct order_id) desc, WEEKDAY(order_date);

-- C. Hourly Trend for Orders
select hour(order_time), count(distinct order_id), row_number() over ()
from pizza_sales
group by hour(order_time);

-- D. % of Sales by Pizza Category
select pizza_category, cast((sum(total_price)/(select sum(total_price) from pizza_sales)*100) as decimal(20,2)),
 round(sum(total_price)/(select sum(total_price) from pizza_sales)*100,2)
from pizza_sales group by pizza_category;

-- E. % of Sales by Pizza Size
select pizza_size,
 cast(
	(sum(total_price)/(select sum(total_price) from pizza_sales))*100
    as decimal(10,2)) 
from pizza_sales group by pizza_size;

-- F. Total Pizzas Sold by Pizza Category
select pizza_category, sum(quantity) 
from pizza_sales group by pizza_category;

-- G. Top 5 Best Sellers by Total Pizzas Sold
select 
	pizza_name,
    total_quantity from (
select
	pizza_name,
	sum(quantity) as total_quantity,
	DENSE_RANK() over (order by sum(quantity) desc) as dense
from pizza_sales
group by pizza_name) x
where dense <= 5;

-- H. Bottom 5 Best Sellers by Total Pizzas Sold
select 
	pizza_name,
    total_quantity from (
select
	pizza_name,
	sum(quantity) as total_quantity,
	DENSE_RANK() over (order by sum(quantity)) as dense
from pizza_sales
group by pizza_name) x
where dense <= 5;

-- MySql function Explanation
-- select dayofweek("2024-08-05");
-- It returns day as a number where 1 refers to Sunday, 2 for Tuesday and so on till 7 which refers to Saturday)
 -- select weekday("2024-08-05");
-- It returns day as a number where 0 refers to Monday, 1 for Tuesday and so on till 6 which refers to Sunday)
