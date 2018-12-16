-- Code to create my VIEW
SELECT
	date,
	a.symbol,
	open,
	close,
	low,
	high,
	volume,
	company,
	sector,
	sub_industry,
	initial_trade_date
FROM prices a
	INNER JOIN securities b 
		ON a.symbol = b.symbol
WHERE a.symbol IN ('CSCO','INTU','FDX','AYI','HOLX','CAH','SJM','SYY','DHI','DIS')
ORDER BY date DESC, sector DESC
LIMIT 10;


-- pg_dump and export commands:
-- 1.  pg_dump -U chris -d hw456 > backup.sql
-- 2.  psql -U chris -d hw456 -tAF, -f hw6.sql > output_file.csv



-- Percent Returns
-- Note: December 30, 2017 was a Saturday so markets were closed
--       I will use Dec. 29, 2017 prices instead
/*
  Stock  |  12/30/2016  |  12/29/2017  |  Percent Return
---------+--------------+--------------+------------------
1. CSCO  |       30.21  |       38.30  |  26.74%
2. INTU  |      114.61  |      157.78  |  37.67%
3. FDX   |      186.19  |      249.54  |  34.02%
4. AYI   |      230.86  |      176.00  |  -23.76%
5. HOLX  |       40.12  |       42.75  |  6.56%
6. CAH   |       71.97  |       61.27  |  -14.87% 
7. SYY   |       55.37  |       60.73  |  9.68%
8. SJM   |      128.06  |      124.24  |  -2.98%
9. DIS   |      104.22  |      107.51  |  3.157%
10. DHI  |       27.33  |       51.07  |  108.62%
*/