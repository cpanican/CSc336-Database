\echo '\nGenerate and label risk scores using temp tables'
CREATE TEMP TABLE risk_score AS (
    SELECT 
        id,
        class,
        SUM(
            CASE WHEN industrial_risk = 'N' THEN 1 ELSE 0 END +
            CASE WHEN management_risk = 'N' THEN 1 ELSE 0 END +
            CASE WHEN financial_flexibility = 'N' THEN 1 ELSE 0 END +
            CASE WHEN credibility = 'N' THEN 1 ELSE 0 END +
            CASE WHEN competitiveness = 'N' THEN 1 ELSE 0 END +
            CASE WHEN operating_risk = 'N' THEN 1 ELSE 0 END 
        ) OVER (PARTITION BY ID) AS risk
    FROM companies
);

CREATE TEMP TABLE risk_score_label AS (
    SELECT 
        id,
        class,
        risk,
        (CASE WHEN risk <= 2 THEN 'Low-risk'
            WHEN risk < 4 THEN 'medium-risk'
            WHEN risk < 5 THEN 'medium-high-risk'
            ELSE 'high-risk' END
        ) AS label 
    FROM risk_score 
);

SELECT * FROM risk_score_label LIMIT 10;

\echo '\nNumber of companies from bankrupt group'
SELECT
    label AS bankrupt_risk_level,
    COUNT(*) AS total
FROM risk_score_label
WHERE class = 'B'
GROUP BY label;

\echo '\nNumber of companies from non-bankrupt group'
SELECT
    label AS non_bankrupt_risk_level,
    COUNT(*) AS total
FROM risk_score_label
WHERE class = 'NB'
GROUP BY label;

\echo '\nCompanies in Medium or higher'
SELECT
    id,
    class,
    label
FROM risk_score_label
WHERE risk > 2
ORDER BY id 
LIMIT 10;
