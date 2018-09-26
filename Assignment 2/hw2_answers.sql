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

-- 2. What are the top ten countries by GNP per capita?
--     (watch out for division by zero here !)

-- 3. What are the ten most densely populated countries, and ten least
--     densely populated countries?

-- 4. What different forms of government are represented in this data?
--     ('DISTINCT' keyword should help here.)

--    Which forms of government are most frequent?
--     (distinct, count, group by order by)

-- 5. Which countries have the highest life expectancy? (watch for NULLs).

-- Getting more serious – joins, joins with conditions, joins that require subqueries:

-- 6. What are the top ten countries by total population, and what is the official language
--     spoken there? (basic inner join)

-- 7. What are the top ten most populated cities – along with which country they are in,
--     and what continent they are on? (basic inner join)

-- 8. What is the official language of the top ten cities you found in Question #7?
--     (three-way inner join).

-- 9. Which of the cities from Question #7 are capitals of their country?
--     (requires a join and a subquery).

-- 10. For the cities found in Question #7, what percentage of the country’s population lives in the capital city?
--     (watch your int’s vs floats !).












