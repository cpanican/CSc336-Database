BEGIN;

DROP TABLE IF EXISTS boats CASCADE;

DROP TABLE IF EXISTS buyers CASCADE;

DROP TABLE IF EXISTS transactions CASCADE;

SET client_encoding = 'LATIN1';

CREATE TABLE boats (
    prod_id,
    brand,
    category,
    cost,
    price
);

CREATE TABLE buyers (
    cust_id,
    fname,
    lname,
    city,
    state,
    referrer
);

CREATE TABLE transactions (
    trans_id,
    cust_id,
    prod_id,
    qty,
    price
);

\COPY boats FROM './boats.csv' WITH (FORMAT csv);

\COPY buyers FROM './buyers.csv' WITH (FORMAT csv);

\COPY transactions FROM './transactions.csv' WITH (FORMAT csv);


-- ALTER TABLE ONLY city
--     ADD CONSTRAINT city_pkey PRIMARY KEY (id);

-- ALTER TABLE ONLY country
--     ADD CONSTRAINT country_pkey PRIMARY KEY (code);

-- ALTER TABLE ONLY countrylanguage
--     ADD CONSTRAINT countrylanguage_pkey PRIMARY KEY (countrycode, "language");

-- ALTER TABLE ONLY country
--     ADD CONSTRAINT country_capital_fkey FOREIGN KEY (capital) REFERENCES city(id);

-- ALTER TABLE ONLY countrylanguage
--     ADD CONSTRAINT countrylanguage_countrycode_fkey FOREIGN KEY (countrycode) REFERENCES country(code);

COMMIT;

ANALYZE boats;
ANALYZE buyers;
ANALYZE transactions;
