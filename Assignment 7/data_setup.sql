BEGIN;

DROP TABLE IF EXISTS census CASCADE;

CREATE TABLE census (
    zip_code integer PRIMARY KEY NOT NULL,
    total_population integer NOT NULL,
    median_age numeric(10,1) NOT NULL,
    total_males integer NOT NULL,
    total_females integer NOT NULL,
    total_households integer NOT NULL,
    avg_household_size numeric(10,1) NOT NULL
);

\COPY locations FROM './census.csv' WITH (FORMAT csv);

COMMIT;
ANALYZE census;