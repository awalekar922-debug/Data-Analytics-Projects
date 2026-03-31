-- Section 2: Financial Health
-- 2.1: D/E Ratio
create view v_debt_to_equity as
select company, year, borrowings, (equity+reserves) as shareholder_equity,
ROUND(borrowings/ nullif((equity+reserves),0),2) as debt_to_equity
from bs_data order by company, year; 

select * from v_debt_to_equity;


-- 2.2: ROE
create view v_roe as
select p.company, p.year, p.net_profit, (b.equity + b.reserves) as shareholder_equity,
ROUND(p.net_profit/nullif((b.equity + b.reserves),0)*100, 2) as roe_pct
from pl_data p join bs_data b on p.company = b.company and p.year = b. year 
order by p.company, p.year; 
select * from v_roe;

-- 2.3: ROA
create view v_roa as
select p.company, p.year, p.net_profit, b.total_assets,
ROUND(p.net_profit/nullif((b.total_assets),0)* 100,2) as roa_pct
from pl_data p join bs_data b on p.company = b.company and p.year = b. year 
order by p.company, p.year; 
select * from v_roa;


-- 2.4: Asset Turnover
create view v_asset_turnover as
select p.company, p.year, p.sales, b.total_assets,
ROUND(p.sales/nullif(b.total_assets,0)*100,2) as asset_turnover
from pl_data p join bs_data b on p.company = b.company and p.year = b. year 
order by p.company, p.year; 
select * from v_asset_turnover;


drop view v_asset_turnover;
create view v_asset_turnover as
select p.company, p.year,p.sales, b.total_assets,
ROUND(p.sales/nullif(b.total_assets,0),2) as asset_turnover
from pl_data p join bs_data b on p.company = b.company and p.year = b.year 
order by p.company, p.year;
select * from v_asset_turnover;












-- 2.5: Cash Ratio
create view v_cash_ratio as 
select company, year, cash_bank, total_liabilities,
ROUND(cash_bank/nullif(total_liabilities,0),2) as cash_ratio
from bs_data order by company, year; 
select * from v_cash_ratio;


















