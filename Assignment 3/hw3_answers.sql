\echo 'HW 3 Submitted by Chris Panican\n'

-- Questions about this data:
\echo '1. We want to spend some advertising money - where should we spend it?'
--     I.e., What is our best referral source of buyers?

SELECT
	referrer,
	count(8)
FROM buyers
GROUP BY referrer
ORDER BY referrer
ASC LIMIT 1;


\echo '2. Who of our customers has not bought a boat?'

SELECT * FROM buyers
WHERE buyers.cust_id NOT IN (
	SELECT transactions.cust_id FROM transactions
);


\echo '3. Which boats have not sold?'

SELECT * FROM boats
WHERE boats.prod_id NOT IN (
	SELECT transactions.prod_id FROM transactions
);


\echo '4. What boat did Alan Weston buy?'

SELECT
	boats.prod_id,
	boats.brand,
	boats.category,
	boats.cost,
	boats.price,
	buyers.fname,
	buyers.lname
FROM boats
INNER JOIN transactions
	ON boats.prod_id = transactions.prod_id
INNER JOIN buyers
	ON transactions.cust_id = buyers.cust_id
WHERE buyers.fname = 'Alan' AND buyers.lname = 'Weston';


\echo '5. Who are our VIP customers?'
-- I.e., Has anyone bought more than one boat?

--     Hint: Think 'WITH' clause, subquery, or UNION. It's probably
--           adviseable to do a subquery first, to get customer id's
--           that appear in the 'transactions' table more than once.
--           Then, after we have those, we can join them with the
--           'buyers' table to get the first and last names.

WITH cust_id_temp AS (
	SELECT buyers.cust_id, count(*) FROM buyers
	INNER JOIN transactions ON buyers.cust_id = transactions.cust_id
	GROUP BY buyers.cust_id
	HAVING count(*) > 1
)
SELECT
	buyers.fname,
	buyers.lname
FROM buyers
INNER JOIN cust_id_temp
	ON cust_id_temp.cust_id = buyers.cust_id
GROUP BY (buyers.fname, buyers.lname);