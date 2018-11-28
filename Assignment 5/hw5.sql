-- Part 1
-- Do the high-performers have any of the following in common?

-- -- Helper functions
-- -- Get last business (trading) day of the year for each year (the last day we have data for in the data set).
-- CREATE TEMP TABLE partitioned_dates AS
-- SELECT 
--     tdate, 
--     ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('year', tdate) ORDER BY tdate DESC) AS num
--     -- could use LAST_VALUE() or FIRST_VALUE() here ...
-- FROM prices
-- WHERE symbol LIKE 'A%'  -- Speedup hack - don't need to check every single symbol. (30ms vs 371ms)
-- ;

-- -- Set up list of last TRADING DAY of year (not last DAY - last TRADING DAY - that's IN the DATA !).
-- CREATE TEMP TABLE year_ends AS
-- SELECT tdate AS year_ends
-- FROM partitioned_dates
-- WHERE num = 1
-- ORDER BY tdate DESC
-- ;

-- Setup Temp table for awesome_fundamentals
CREATE TEMP TABLE awesome_fundamentals AS
    SELECT t1.* FROM fundamentals t1
    INNER JOIN awesome_performers t2 
        ON t1.symbol = t2.symbol
    ORDER BY t1.symbol;

-- select * from awesome_fundamentals limit 10;



-- High net worth (total assets - total expenses)
--     Or: (even better) high net worth growth year-over-year
CREATE TEMP TABLE net_worth_yearly AS
    SELECT
        symbol,
        year,
        ((total_assets - total_liabilities)/LEAD((total_assets - total_liabilities)::NUMERIC) OVER (
            PARTITION BY symbol ORDER BY year DESC
        ))::NUMERIC(10,2) - 1 AS net_growth
    FROM awesome_fundamentals;
-- Show top 10 companies with positive net growth.
-- SELECT * FROM net_worth_yearly WHERE net_growth > 0 ORDER BY net_growth DESC LIMIT 10;



-- High net income growth year-over-year?
CREATE TEMP TABLE net_income_yearly AS
    SELECT
        symbol,
        year,
        (net_income/LEAD((net_income)::NUMERIC) OVER (
            PARTITION BY symbol ORDER BY year DESC
        ))::NUMERIC(10,2) - 1 AS net_inc_growth
    FROM awesome_fundamentals;
-- Show top 10 companies with positive net income growth
-- SELECT * FROM net_income_yearly WHERE net_inc_growth > 0 ORDER BY net_inc_growth DESC LIMIT 10;



-- High revenue growth year-over-year?
CREATE TEMP TABLE revenue_growth_yearly AS
    SELECT
        symbol,
        year,
        (total_revenue/LEAD((total_revenue)::NUMERIC) OVER (
            PARTITION BY symbol ORDER BY year DESC
        ))::NUMERIC(10,2) - 1 AS revenue_growth
    FROM awesome_fundamentals;
-- Show top 10 companies with positive revenue growth
-- SELECT * FROM revenue_growth_yearly WHERE revenue_growth > 0 ORDER BY revenue_growth DESC LIMIT 10;



-- High earnings-per-share?
--     High earnings-per-share (eps) growth?
CREATE TEMP TABLE eps_growth_yearly AS
    SELECT
        symbol,
        year,
        (earnings_per_share/LEAD((earnings_per_share)::NUMERIC) OVER (
            PARTITION BY symbol ORDER BY year DESC
        ))::NUMERIC(10,2) - 1 AS eps_growth
    FROM awesome_fundamentals;
-- Show top 10 companies with positive eps growth
-- SELECT * FROM eps_growth_yearly WHERE eps_growth > 0 ORDER BY eps_growth DESC LIMIT 10;



-- Low price-to-earnings ratio?
--     (this is stock price relative to eps - i.e.: pe ratio = share price / eps)
CREATE TEMP TABLE price_to_earning AS
    SELECT
        t1.symbol,
        t1.year,
        (t2.close/t1.earnings_per_share)::NUMERIC(10,2) AS price_to_earning_ratio
    FROM awesome_fundamentals t1
    INNER JOIN prices t2
        ON t1.year_ending = t2.date AND t1.symbol = t2.symbol
    ORDER BY t1.symbol;
-- Show top 10 companies and year with the highest price to earning ratio
-- SELECT * FROM price_to_earning WHERE price_to_earning_ratio > 0 ORDER BY price_to_earning_ratio DESC LIMIT 10;



-- Amount of liquid cash in the bank vs. total liabilities?
CREATE TEMP TABLE liquid_vs_liabilities AS
    SELECT
        symbol,
        year,
        (total_liabilities/cash_and_cash_equivalents::NUMERIC) AS liquid_liabilities_ratio
    FROM awesome_fundamentals;
-- Show top 10 companies with positive liquid asset and liabilities ratio
-- SELECT * from liquid_vs_liabilities ORDER BY liquid_liabilities_ratio DESC LIMIT 10;



-- Part 2

-- These factors had a huge contribution to high performance of all companies:
--     1. net_income_yearly
--     2. revenue_growth_yearly
--     3. eps_growth_yearly

CREATE TEMP TABLE potential_candidates AS
    SELECT
        symbol,
        year,
        (net_income/LEAD((net_income)::NUMERIC) OVER (
            PARTITION BY symbol ORDER BY year DESC
        ))::NUMERIC(10,2) - 1 AS net_inc_growth,
        (total_revenue/LEAD((total_revenue)::NUMERIC) OVER (
            PARTITION BY symbol ORDER BY year DESC
        ))::NUMERIC(10,2) - 1 AS revenue_growth,
        (earnings_per_share/LEAD((earnings_per_share)::NUMERIC) OVER (
            PARTITION BY symbol ORDER BY year DESC
        ))::NUMERIC(10,2) - 1 AS eps_growth
    FROM fundamentals
    ORDER BY symbol;

SELECT
    t1.symbol,
    t2.company,
    t2.sector,
    t1.year,
    t1.net_inc_growth,
    t1.revenue_growth,
    t1.eps_growth
FROM potential_candidates t1
INNER JOIN securities t2
    ON t1.symbol = t2.symbol
WHERE 
    year='2016' AND
    (net_inc_growth > 0.02) AND
    (revenue_growth BETWEEN 0 AND 0.5) AND
    (eps_growth > 0.15);



-- Part 3
-- From this list, select 10 companies to invest in.
-- No more then 2 companies in the same sector

-- Information Technology
-- 1. CSCO | Cisco Systems
-- 2. INTU | Intuit Inc.

-- Health Care
-- 3. CAH  | Cardinal Health Inc.
-- 4. HOLX | Hologic

-- Industrials
-- 5. AYI  | Acuity Brands Inc
-- 6. FDX  | FedEx Corporation

-- Consumer Staples
-- 7. SJM  | JM Smucker
-- 8. SYY  | Sysco Corp.

-- Consumer Discretionary
-- 9. DHI  | D. R. Horton
-- 10. DIS | The Walt Disney Company



-- Extra credit
