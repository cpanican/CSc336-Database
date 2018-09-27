-- Submitted by Chris Panican
-- 2. Is this database in Normal Form?

--     If so, which one is it in? 1NF, 2NF, 3NF?
--     if not, what is preventing it to be normalized? Can it be normalized?

--     Hints:
--     Look directly at the data, and also at the CREATE TABLE and ALTER TABLE
--         statements in the world_data.sql file.
--     The tables also have CONSTRAINTs - that do they tell you?
--     

-- Part II: Queries

-- Warm-ups: Some SQL practice:

-- 1. What are the top ten countries by economic activity (Gross National Product - 'gnp').
SELECT
    name,
    gnp
FROM country
ORDER BY gnp
DESC LIMIT 10;

-- 2. What are the top ten countries by GNP per capita?
--     (watch out for division by zero here !)
WITH gnp_null_filtered AS (
    SELECT
        name,
        gnp / NULLIF(population, 0)
            AS gnp_per_capita
    FROM country
)
SELECT *
FROM gnp_null_filtered
WHERE gnp_per_capita IS NOT NULL
ORDER BY gnp_per_capita
DESC LIMIT 10;

-- 3. What are the ten most densely populated countries, and ten least
--     densely populated countries?

-- Top 10 most densely populated countries
SELECT
    name,
    population / NULLIF(surfacearea, 0)
        AS population_density
FROM country
ORDER BY population_density
DESC LIMIT 10;

-- Top 10 least densely populated countries
SELECT
    name,
    NULLIF(population, 0) / NULLIF(surfacearea, 0)
        AS population_density
FROM country
ORDER BY population_density
ASC LIMIT 10;

-- 4. What different forms of government are represented in this data?
--     ('DISTINCT' keyword should help here.)
SELECT DISTINCT governmentform FROM country;

--    Which forms of government are most frequent?
--     (distinct, count, group by order by)
SELECT DISTINCT
    governmentform,
    COUNT(governmentform)
FROM country
GROUP BY governmentform
ORDER BY count DESC;

-- 5. Which countries have the highest life expectancy? (watch for NULLs).
SELECT
    name,
    lifeexpectancy
FROM country
WHERE
    lifeexpectancy IS NOT NULL
ORDER BY lifeexpectancy
DESC lIMIT 10;


-- Getting more serious – joins, joins with conditions, joins that require subqueries:

-- 6. What are the top ten countries by total population, and what is the official language
--     spoken there? (basic inner join)
SELECT
    country.name,
    country.population,
    countrylanguage.language
FROM country
INNER JOIN countrylanguage
    ON country.code = countrylanguage.countrycode
WHERE countrylanguage.isofficial = 't'
ORDER BY country.population
DESC LIMIT 10;

-- 7. What are the top ten most populated cities – along with which country they are in,
--     and what continent they are on? (basic inner join)
SELECT
    city.name,
    city.population,
    country.name,
    country.continent
FROM city
INNER JOIN country
    ON city.countrycode = country.code
ORDER BY city.population
DESC LIMIT 10;

-- 8. What is the official language of the top ten cities you found in Question #7?
--     (three-way inner join).
SELECT
    city.name,
    city.population,
    country.name,
    country.continent,
    countrylanguage.language
FROM city
INNER JOIN country
    ON city.countrycode = country.code
INNER JOIN countrylanguage
    ON country.code = countrylanguage.countrycode
WHERE countrylanguage.isofficial = 't'
ORDER BY city.population
DESC LIMIT 10;

-- 9. Which of the cities from Question #7 are capitals of their country?
--     (requires a join and a subquery).

-- 10. For the cities found in Question #7, what percentage of the country’s population lives in the capital city?
--     (watch your int’s vs floats !).












