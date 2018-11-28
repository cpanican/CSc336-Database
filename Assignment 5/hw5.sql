-- Part 1
-- Do the high-performers have any of the following in common?

-- Helper functions
-- Get last business (trading) day of the year for each year (the last day we have data for in the data set).
CREATE TEMP TABLE partitioned_dates AS
SELECT 
    tdate, 
    ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('year', tdate) ORDER BY tdate DESC) AS num
    -- could use LAST_VALUE() or FIRST_VALUE() here ...
FROM prices
WHERE symbol LIKE 'A%'  -- Speedup hack - don't need to check every single symbol. (30ms vs 371ms)
;

-- Set up list of last TRADING DAY of year (not last DAY - last TRADING DAY - that's IN the DATA !).
CREATE TEMP TABLE year_ends AS
SELECT tdate AS year_ends
FROM partitioned_dates
WHERE num = 1
ORDER BY tdate DESC
;

-- Setup Temp table for awesome_fundamentals
CREATE TEMP TABLE awesome_fundamentals AS
    SELECT *
    FROM fundamentals
    INNER JOIN awesome_performers
    ON fundamentals.symbol = awesome_performers.symbol
    ORDER BY fundamentals.symbol


-- High net worth (total assets - total expenses)
--     Or: (even better) high net worth growth year-over-year

-- High net income growth year-over-year?

-- High revenue growth year-over-year?

-- High earnings-per-share?
--     High earnings-per-share (eps) growth?
-- Low price-to-earnings ratio?
--     (this is stock price relative to eps - i.e.: pe ratio = share price / eps)

-- Amount of liquid cash in the bank vs. total liabilities?


-- Part 2

-- Part 3




-- Extra credit