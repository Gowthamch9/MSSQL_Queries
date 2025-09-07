select *
from pizza
order by pizza_id;

-----------------------------------------------------------------------------------
--1) What are the total sales revenue and total orders by day, week, and month?

--DAY SALES and orders----
select Order_Day,
       count(total_orders) as TotalOrders,
       sum(total_price) as TotalSalesbyDay
from pizza
group by Order_Day
order by TotalSalesbyDay desc;

select pizza_id,format(order_date, 'MMMM') as month
from pizza
order by pizza_id;

alter table pizza
add Month varchar(20);

update pizza
set Month = format(order_date, 'MMMM')
            from pizza;


--Monthly SALES and orders-----------------
select Month,
       count(total_orders) as TotalOrders,
       sum(total_price) as TotalSalesbyMonth
from pizza
group by Month
order by TotalSalesbyMonth desc;


select datepart(wk, order_date) as weeknumber
from pizza
order by weeknumber;

alter table pizza
add weeknumber int;

update pizza
set weeknumber = datepart(wk, order_date)
                 from pizza

--Weekly SALES and orders-----------------
select weeknumber,
       count(total_orders) as TotalOrders,
       sum(total_price) as TotalSalesbyWeek
from pizza
group by weeknumber
order by TotalSalesbyWeek desc;

select CURRENT_TIMESTAMP 

------------------------------------------------
--2)Which pizza categories (e.g., Classic, Veggie, Supreme, etc.) generate the highest sales revenue?

Select pizza_category,
       Sum(total_price) as TotalCategorySales
from pizza
group  by pizza_category
order by TotalCategorySales desc;

----------------------------------------------------
--3) What are the top 10 best-selling pizzas by revenue and by quantity sold?

select top 10 pizza_name,
       sum(total_price) as TotalSales,
       count(qunatity) as TotalQuantity
from pizza
group by pizza_name
order by TotalSales desc, TotalQuantity desc;

---------------------------------------------------------
--4) Which pizzas contribute to the lowest sales (underperformers)?
select top 5 pizza_name,
             sum(total_price) as TotalSales
from pizza
group by pizza_name
order by Totalsales;


----------------------------------------------------------
--5)What is the average order value (AOV) and how has it changed over time?
with AOV as (
select Month(order_date) as MonthNumber,
       Month,
       sum(total_price) * 1.0/count(distinct order_id) as AverageOrderValue
from pizza
group by Month(order_date),Month),

AOV1 as(
select MonthNumber,
       Month,
       AverageOrderValue,
       lag(AverageOrderValue) over (order by MonthNumber) as PreviousMonthSales,
       lag(Month) over (order by MonthNumber) as PreviousMonth,
       case 
       when AverageOrderValue > lag(AverageOrderValue) over (order by MonthNumber) then 'Increasing'
       when AverageOrderValue < lag(AverageOrderValue) over (order by MonthNumber) then 'Decreasing'
       when lag(AverageOrderValue) over (order by MonthNumber) is null then 'Initial Month'
       else 'same'
       end as MonthlySalesComparision,
       AverageOrderValue - lag(AverageOrderValue) over (order by MonthNumber) as AVGDiff 
from AOV)

select MonthNumber,
       Month,
       AverageOrderValue,
       PreviousMonth,
       PreviousMonthSales,
       MonthlySalesComparision,
       AVGDiff,
       Rank() over (order by AVGDiff desc) as AvgRankOrder
from AOV1
order by AvgRankOrder;



