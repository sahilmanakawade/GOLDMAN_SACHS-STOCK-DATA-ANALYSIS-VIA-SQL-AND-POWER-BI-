create database gs; -- created a database

use gs; -- using a database

set sql_safe_updates=0;-- set safe_mode off for modification 

create table goldman_sachs( -- created a table
Date date primary key,
Open double ,
High double,
Low double,
Close double,
Adj_close double,
Volume bigint);

select * from goldman_sachs-- check for no of trading days

ALTER TABLE goldman_sachs -- INSERTING A COLUMN OF MONTH 
ADD MONTH VARCHAR(50)

UPDATE goldman_sachs
SET MONTH = MONTHNAME(DATE) -- GETTING THE MONTH NAME FROM THE TABLE 

ALTER TABLE goldman_sachs-- INSERTING A COLUMN OF DAY 
ADD DAY VARCHAR(50)

UPDATE goldman_sachs -- GETTING THE DAY NAME FROM THE TABLE 
SET DAY = DAYNAME(DATE)

ALTER TABLE goldman_sachs -- INSERTING A COLUMN OF QUARTER 
ADD QUARTER VARCHAR(10)

UPDATE goldman_sachs -- GETTING THE QUARTER FROM THE TABLE  (Q1,Q2,Q3,Q4 FOR THE YEAR)
SET QUARTER = CONCAT("Q","",QUARTER(DATE))

SELECT AVG(HIGH),-- GIVES THE AVERAGE OF HIGHEST PRICES IN 52 WEEKS
 AVG(LOW),-- GIVES THE AVERAGE OF HIGHEST PRICES IN 52 WEEKS
 AVG(CLOSE),-- GIVES THE AVERAGE OF CLOSING PRICES,
 AVG(OPEN),-- GIVES THE AVERAGE OF OPENING PRICES ; 
 SUM(VOLUME) AS TOTAL_VOLUME_TRADED FROM goldman_sachs

select a.date,b.date,((a.close-b.close)/b.close)*100 as "%_return_in_1_year" from goldman_sachs a
join goldman_sachs b
on datediff(a.date,b.date) in (366)

select a.date,b.date,((a.close-b.close)/b.close)*100 as "%_return_in_6_month" from goldman_sachs a
join goldman_sachs b
on datediff((select max(a.date) from goldman_sachs),(select max(b.date) from goldman_sachs) )in (183) 
order by a.date desc 
limit 1 

select a.date,b.date,((a.close-b.close)/b.close)*100 as "%_return_in_1_month" from goldman_sachs a
join goldman_sachs b
on datediff((select max(a.date) from goldman_sachs),(select max(b.date) from goldman_sachs) )in (30,31) 
order by a.date desc 
limit 1

select a.date,b.date,((a.close-b.close)/b.close)*100 as "%_return_in_1_week" from goldman_sachs a
join goldman_sachs b
on datediff((select max(a.date) from goldman_sachs),(select max(b.date) from goldman_sachs) )in (7) 
order by a.date desc 
limit 1

SELECT date, open, close, volume,       -- HIGHEST VOLUME TRADED DAYS
NTILE(10) OVER (ORDER BY volume DESC) AS volume_rank
FROM goldman_sachs

SELECT date, ((close-open)/open)*100 AS "%p/l_HIGH_VOLUME_DAYS", --  %p/l_HIGH_VOLUME_DAYS,
NTILE(10) OVER (ORDER BY volume DESC) AS volume_rank,if((((close-open)/open)*100)>0,"P","L") AS "p/l"
FROM goldman_sachs

SELECT -- ROLLIMG MOVING AVERAGE
    date,
    close,
    AVG(close) OVER (
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7_days
FROM goldman_sachs;



