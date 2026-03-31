-- Section 1: Growth Trends
-- 1.1 Yeay on year revenue growth
select company, year, sales,
LAG(sales) over (partition by company order by year) as prev_year_sales,
ROUND((sales-lag(sales) over (partition by company order by year))/LAG(sales) over (partition by company order by year)*100,2)
as revenue_growth_pct from pl_data order by company , year; 

-- 1.2 YOY net profit growth
select company, year, net_profit, 
LAG(net_profit) over(partition by company order by year) as prev_year_profit,
Round((net_profit-lag(net_profit) over (partition by company order by year))/ LAG(net_profit) over (partition by company order by year)*100,2)
as profit_growth_pct from pl_data order by company, year;

--1.3 YOY operating profit growth
select company, year, operating_profit,
round((operating_profit-LAG(operating_profit) over (partition by company order by year))/LAG(operating_profit) over (partition by company order by year) *100,2)
as op_profit_growth_pct from pl_data order by company, year; 


--VIEWS for RATIO  ANALYSIS
--1.1
CREATE VIEW v_revenue_growth AS
SELECT company, year, sales,
 LAG(sales) OVER (PARTITION BY company ORDER BY year) AS prev_year_sales,
 ROUND((sales - LAG(sales) OVER (PARTITION BY company ORDER BY year))/LAG(sales) OVER (PARTITION BY company ORDER BY year) * 100, 2) AS revenue_growth_pct
FROM pl_data ORDER BY company, year;
select * from v_revenue_growth;



-- 1.2
create view v_profit_growth as
SELECT company, year, net_profit,
LAG(net_profit) OVER (PARTITION BY company ORDER BY year) AS prev_year_profit,
ROUND((net_profit - LAG(net_profit) OVER (PARTITION BY company ORDER BY year))/LAG(net_profit) OVER (PARTITION BY company ORDER BY year) * 100, 2) AS profit_growth_pct
FROM pl_data ORDER BY company, year;
select * from v_profit_growth; 

--1.3
CREATE VIEW v_op_profit_growth AS
SELECT company, year, operating_profit,
ROUND((operating_profit - LAG(operating_profit) OVER (PARTITION BY company ORDER BY year))/LAG(operating_profit) OVER (PARTITION BY company ORDER BY year) * 100, 2) AS op_profit_growth_pct
FROM pl_data ORDER BY company, year;
select* from v_op_profit_growth;

select * from v_revenue_growth;
select * from v_profit_growth;
select * from v_op_profit_growth;



















