BEGIN;

DROP TABLE IF EXISTS companies CASCADE;

CREATE TABLE companies (
    id integer PRIMARY KEY NOT NULL,
    industrial_risk text NOT NULL,
    management_risk text NOT NULL,
    financial_flexibility text NOT NULL,
    credibility text NOT NULL,
    competitiveness text NOT NULL,
    operating_risk text NOT NULL,
    class text NOT NULL
);

\COPY companies FROM './ids.csv' WITH (FORMAT csv);

COMMIT;
ANALYZE companies;