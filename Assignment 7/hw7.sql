\echo '\nCreate a temp table to seperate zip code 93591'
CREATE TEMP TABLE target_zip AS (
    SELECT * FROM census
    WHERE zip_code = 93591
);

\echo '\nCalculate distances from target zip code'
WITH distances AS (
    SELECT
        b.zip_code,
        SQRT(
            POWER(a.median_age - b.median_age, 2) +
            POWER(a.total_males - b.total_males, 2) +
            POWER(a.avg_household_size - b.avg_household_size, 2)
        ) AS distance_from_zip
    FROM
        target_zip a,
        census b
    WHERE
        b.total_population != 0
)
SELECT * FROM distances
ORDER BY distance_from_zip ASC
LIMIT 10 OFFSET 1;
