-- Section 3: Competitive Comparison
-- 3.1: Net Profit Margin
create view v_profit_margin as
select company, year, sales, net_profit,
ROUND(net_profit/nullif(sales,0)*100,2) as net_margin_pct
from pl_data order by company, year;
select * from v_profit_margin;


-- 3.2: Operating Profit Margin
create view v_operating_margin as
select company, year, sales, operating_profit,
ROUND(operating_profit/nullif(sales,0)*100, 2) as operating_margin_pct
from pl_data order by company, year;
select * from v_operating_margin;


-- 3.3: Revenue Market Share
create view v_market_share as
select company, year, sales, 
ROUND(sales/sum(sales) over (partition by year) * 100, 2) as revenue_market_share_pct
from pl_data order by year, company;
select * from v_market_share;


-- 3.4: Receivables to Revenue
create view v_receivable_revenue as
select p.company, p.year, b.receivables, p.sales,
ROUND(b.receivables/nullif(p.sales,0)*100,2) as receivables_to_revenue_pct
from pl_data p join bs_data b on p.company = b.company and p.year = b.year 
order by p.company, p. year; 
select * from v_receivable_revenue;









