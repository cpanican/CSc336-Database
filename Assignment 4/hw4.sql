-- Queries to answer #2

CREATE TEMP TABLE assign_unique_dates AS (
    WITH remove_duplicate_dates AS (
        SELECT DISTINCT "date"
        FROM prices
        ORDER BY "date"
    )
    SELECT
        "date",
        ROW_NUMBER() OVER (
            PARTITION BY EXTRACT("year" FROM "date")
            ORDER BY "date" DESC
        )
    FROM remove_duplicate_dates
    ORDER BY "date"
);

CREATE TEMP TABLE year_end_prices AS (
    WITH year_end_dates AS (
        SELECT "date"
        FROM assign_unique_dates
        WHERE row_number = 1
        ORDER BY "date"
    )
    SELECT 
        symbol,
        EXTRACT("year" FROM "date") AS "year",
        "close" AS end_price
    FROM prices
    WHERE "date" IN (
        SELECT * 
        FROM year_end_dates
    )
    ORDER by symbol, date
);

CREATE TEMP TABLE best_year_returns AS (
    SELECT 
        "symbol",
        "year",
        LAG(end_price) OVER (
            PARTITION BY "symbol"
            ORDER BY "year"
        ) AS "start_price",
        end_price,
        (end_price/LAG(end_price) OVER (
            PARTITION BY "symbol"
            ORDER BY "year")) - 1
        AS annual_returns
    FROM year_end_prices
);

SELECT *
FROM best_year_returns
WHERE annual_returns IS NOT NULL
ORDER BY annual_returns DESC;

-- Queries to answer #3

DROP TABLE IF EXISTS awesome_performers CASCADE;

CREATE TABLE awesome_performers AS
    WITH top_100_companies AS (
        SELECT
            *,
            ROW_NUMBER() OVER (
                ORDER BY annual_returns DESC
            ) AS row
        FROM best_year_returns
        WHERE annual_returns IS NOT NULL
        ORDER BY annual_returns DESC
        LIMIT 100
    )
    SELECT
        symbol,
        "year",
        start_price,
        end_price,
        annual_returns
    FROM top_100_companies
    WHERE "row" % 2 = 0;

SELECT * FROM awesome_performers;
