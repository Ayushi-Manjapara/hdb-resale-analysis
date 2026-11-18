
-- How have annual resale prices changed for each flat type?
WITH yearly_resale AS (
SELECT 
	resale_year, 
	flat_type, 
	COUNT(*) AS transaction_count, 
	ROUND(AVG(resale_price),2) as avg_resale_price
FROM hdb_resale_clean
GROUP BY resale_year, flat_type
)
SELECT 
	resale_year, 
	flat_type,
	transaction_count,
	LAG(transaction_count) OVER (PARTITION BY flat_type ORDER BY resale_year) as prev_year_transactions,
	avg_resale_price,
	LAG(avg_resale_price) OVER (PARTITION BY flat_type ORDER BY resale_year) as prev_year_avg
FROM yearly_resale
ORDER BY flat_type, resale_year;

-- How has the average price per sqm changed over the years?
WITH yearly_resale_sqm AS (
SELECT
	resale_year,
	AVG(price_per_sqm) as avg_price_per_sqm
	FROM hdb_resale_clean
	GROUP BY resale_year	
)
SELECT 
	resale_year,
	avg_price_per_sqm,
	LAG(avg_price_per_sqm) OVER (ORDER BY resale_year) AS prev_year_price_sqm,
	((avg_price_per_sqm - LAG(avg_price_per_sqm) OVER (ORDER BY resale_year))/LAG(avg_price_per_sqm) OVER (ORDER BY resale_year)) * 100 AS yoy_change_impact
FROM yearly_resale_sqm
ORDER BY resale_year;

-- Which year recorded the highest and lowest average resale prices?
WITH yearly_resale AS (
SELECT
	resale_year,
	ROUND(AVG(resale_price),2) as avg_resale_price
	FROM hdb_resale_clean
	GROUP BY resale_year
)
SELECT
    'Lowest' AS price_category,
	resale_year,
	avg_resale_price
	FROM yearly_resale
	WHERE avg_resale_price = 
		(SELECT MIN(avg_resale_price) FROM yearly_resale)
		
UNION ALL

SELECT
	'Highest' AS price_category,
	resale_year,
	avg_resale_price
	FROM yearly_resale
	WHERE avg_resale_price = 
		(SELECT max(avg_resale_price) FROM yearly_resale);

-- Which towns have the highest average resale prices?
SELECT
	town,
	ROUND(AVG(resale_price),2) AS avg_resale_price
FROM hdb_resale_clean
GROUP BY town 
ORDER BY avg_resale_price DESC;

-- Which towns have the highest number of resale transactions?
SELECT
	town,
	COUNT(*) AS total_transactions,
	ROUND(AVG(resale_price),2) AS avg_resale_price
FROM hdb_resale_clean
GROUP BY town 
ORDER BY total_transactions DESC;

-- Which flat types have the highest average resale prices within each town?
WITH town_flat_prices AS(
	SELECT
		town,
		flat_type,
		ROUND(AVG(resale_price),2) AS avg_resale_price
	FROM hdb_resale_clean
	GROUP BY town, flat_type
)
SELECT
	town,
	flat_type,
	avg_resale_price,
	DENSE_RANK() OVER(PARTITION BY town ORDER BY avg_resale_price DESC) AS price_rank
FROM town_flat_prices
ORDER BY town, price_rank, flat_type;

-- How does average resale price per sqm vary by property age group?
WITH property_age_range AS (
	SELECT
		CASE
			WHEN property_age < 10 THEN 'Under 10 years'
			WHEN property_age BETWEEN 10 AND 19 THEN '10-19 years'
			WHEN property_age BETWEEN 20 AND 29 THEN '20-29 years'
			WHEN property_age BETWEEN 30 AND 39 THEN '30-39 years'
			ELSE '40 years and above'
			END AS property_age_range,
			price_per_sqm
			FROM hdb_resale_clean
)
SELECT 
	property_age_range,
	ROUND(AVG(price_per_sqm),2) AS average_price_sqm
FROM property_age_range
GROUP BY property_age_range
ORDER BY property_age_range;

-- How does average resale price per sqm vary across storey ranges?
SELECT 
	storey_range,
	ROUND(AVG(price_per_sqm),2) AS average_price_sqm
FROM hdb_resale_clean
GROUP BY storey_range
ORDER BY ROUND(AVG(price_per_sqm),2) DESC;