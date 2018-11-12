BEGIN;

DROP TABLE IF EXISTS securities CASCADE;

DROP TABLE IF EXISTS fundamentals CASCADE;

DROP TABLE IF EXISTS prices CASCADE;

-- Table setup

CREATE TABLE securities (
    "symbol" varchar(5) NOT NULL,
    "company" text NOT NULL,
    "sector" text NOT NULL,
    "sub_industry" text NOT NULL,
    "initial_trade_date" date
);

CREATE TABLE fundamentals (
    "id" integer NOT NULL,
    "symbol" varchar(5) NOT NULL,
    "year_ending" date NOT NULL,
    "cash_and_cash_equivalents" bigint NOT NULL,
    "earnings_before_interest_and_taxes" bigint NOT NULL,
    "gross_margin" smallint NOT NULL,
    "net_income" bigint NOT NULL,
    "total_assets" bigint NOT NULL,
    "total_liabilities" bigint NOT NULL,
    "total_revenue" bigint NOT NULL,
    "year" varchar(5) NOT NULL,
    "earnings_per_share" numeric(4,2),
    "shares_outstanding" numeric
);

CREATE TABLE prices (
    "date" date NOT NULL,
    "symbol" varchar(5) NOT NULL,
    "open" numeric NOT NULL,
    "close" numeric NOT NULL,
    "low" numeric NOT NULL,
    "high" numeric NOT NULL,
    "volume" integer NOT NULL
);

-- Data import

\COPY securities FROM './securities.csv' WITH (FORMAT csv);

\COPY fundamentals FROM './fundamentals.csv' WITH (FORMAT csv);

\COPY prices FROM './prices.csv' WITH (FORMAT csv);

-- Primary Keys

ALTER TABLE ONLY securities
    ADD CONSTRAINT securities_pkey PRIMARY KEY (symbol);

ALTER TABLE ONLY fundamentals
    ADD CONSTRAINT fundamentals_pkey PRIMARY KEY (id);

ALTER TABLE ONLY prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (date, symbol);

-- References

ALTER TABLE ONLY fundamentals
    ADD CONSTRAINT fundamentals_fkey FOREIGN KEY (symbol) REFERENCES securities(symbol);

ALTER TABLE ONLY prices
    ADD CONSTRAINT prices_fkey FOREIGN KEY (symbol) REFERENCES securities(symbol);

COMMIT;

ANALYZE securities;
ANALYZE fundamentals;
ANALYZE prices;
