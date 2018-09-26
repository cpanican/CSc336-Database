/*  DBase Assn 1:

    Passengers on the Titanic:
        1,503 people died on the Titanic.
        - around 900 were passengers, 
        - the rest were crew members.

    This is a list of what we know about the passengers.
    Some lists show 1,317 passengers, 
        some show 1,313 - so these numbers are not exact, 
        but they will be close enough that we can spot trends and correlations.

    Lets' answer some questions about the passengers' survival data: 
 */

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- DELETE OR COMMENT-OUT the statements in section below after running them ONCE !!
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*  Create the table and get data into it: */

-- DROP TABLE IF EXISTS passengers;

-- CREATE TABLE passengers (
--     id INTEGER NOT NULL,
--     lname TEXT,
--     title TEXT,
--     class TEXT, 
--     age FLOAT,
--     sex TEXT,
--     survived INTEGER,
--     code INTEGER
-- );

-- Now get the data into the database:
-- \COPY passengers FROM './titanic.csv' WITH (FORMAT csv);

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- DELETE OR COMMENT-OUT the statements in the above section after running them ONCE !!
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/* Some queries to get you started:  */


-- How many total passengers?: 1313
SELECT COUNT(*) AS total_passengers FROM passengers;


-- How many survived? 450
SELECT COUNT(*) AS survived FROM passengers WHERE survived=1;


-- How many died? 863
SELECT COUNT(*) AS did_not_survive FROM passengers WHERE survived=0;


-- How many were female? Male? 462, 851
SELECT COUNT(*) AS total_females FROM passengers WHERE sex='FEMALE';
SELECT COUNT(*) AS total_males FROM passengers WHERE sex='MALE';


-- How many total females died?  Males? 154, 709
SELECT COUNT(*) AS no_survived_females FROM passengers WHERE sex='FEMALE' AND survived=0;
SELECT COUNT(*) AS no_survived_males FROM passengers WHERE sex='MALE' AND survived=0;


-- Percentage of females of the total? 35.1865955826352
SELECT 
    SUM(CASE WHEN sex='FEMALE' THEN 1.0 ELSE 0.0 END) / 
        CAST(COUNT(*) AS FLOAT)*100 
            AS tot_pct_female 
FROM passengers;


-- Percentage of males of the total? 64.8134044173648
SELECT 
    SUM(CASE WHEN sex='MALE' THEN 1.0 ELSE 0.0 END) / 
        CAST(COUNT(*) AS FLOAT)*100 
            AS tot_pct_male 
FROM passengers;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%% Write queries that will answer the following questions:  %%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


-- 1.  What percent of passengers survived? (total)
SELECT
    SUM(CASE WHEN survived=1 THEN 1.0 ELSE 0.0 END) /
        CAST(COUNT(*) AS FLOAT)*100
            AS passengers_survived_pct
FROM passengers;


-- 2.  What percentage of females survived?     (female_survivors / tot_females)
SELECT
    SUM(CASE WHEN survived=1 AND sex='female' THEN 1.0 ELSE 0.0 END) /
        CAST(SUM(CASE WHEN sex='female' THEN 1.0 ELSE 0.0 END) AS FLOAT)*100
            AS tot_pct_female_survived
FROM passengers;


-- 3.  What percentage of males that survived?      (male_survivors / tot_males)
SELECT
    SUM(CASE WHEN survived=1 AND sex='male' THEN 1.0 ELSE 0.0 END) /
        CAST(SUM(CASE WHEN sex='male' THEN 1.0 ELSE 0.0 END) AS FLOAT)*100
            AS tot_pct_male_survived
FROM passengers;

-- 4.  How many people total were in First class, Second class, Third class, or of class unknown ?
SELECT
    class,
    COUNT(*) AS total_passengers
FROM passengers
GROUP BY class
ORDER BY class;

-- 5.  What is the total number of people in First and Second class ?
SELECT
    class,
    COUNT(*) AS total_passengers
FROM passengers
WHERE
    class IS NOT NULL AND class != '3rd'
GROUP BY class
ORDER BY class;

-- 6.  What are the survival percentages of the different classes? (3).
SELECT
    class,
    SUM(CASE WHEN survived=1 THEN 1.0 ELSE 0.0 END) /
        CAST(COUNT(*) AS FLOAT)*100
            AS survival_per_class
FROM passengers
GROUP BY class
ORDER BY class
LIMIT 3;

-- 7.  Can you think of other interesting questions about this dataset?
--      I.e., is there anything interesting we can learn from it?  
--      Try to come up with at least two new questions we could ask.

--      Example:
--      Can we calcualte the odds of survival if you are a female in Second Class?

--      Could we compare this to the odds of survival if you are a female in First Class?
--      If we can answer this question, is it meaningful?  Or just a coincidence ... ?
        
--      Question:
--      What are the top 10 most common first names from the data we have?


-- 8.  Can you answer the questions you thought of above?
--      Are you able to write the query to find the answer now?  

--      If so, try to answer the question you proposed.
--      If you aren't able to answer it, try to answer the following:
--      Can we calcualte the odds of survival if you are a female in Second Class?

-- Answer to question. Using PostgreSQL:
SELECT
    SPLIT_PART(title, ' ', 1) AS first_names,
    count(*)
FROM passengers
GROUP BY first_names
ORDER BY COUNT(*) DESC
LIMIT 10;

--        Output
--  first_names | count
-- -------------+-------
--  William     |    69
--  John        |    58
--  Charles     |    30
--  George      |    29
--  Thomas      |    25
--  James       |    23
--  Frederick   |    20
--  Henry       |    20
--  Edward      |    19
--  Joseph      |    18


-- 9.  If someone asserted that your results for Question #8 were incorrect,
--     how could you defend your results, and verify that they are indeed correct?

--     My answer from number 8 would be incorrect if the user is not using Postgres since
--     I am using a function called `split_part` which may not work on different database
--     management systems.

/*
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Email me ONLY this document - as an attachment.  You may just fill in your answers above.

    Do NOT send any other format except for one single .sql file.

    ZIP folders, word documents, and any other format (other than .sql) will receive zero credit.

    Do NOT copy and paste your queries into the body of the email.

    Your sql should run without errors - please test it beforehand.

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/


