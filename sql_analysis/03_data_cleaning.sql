-- raw data passed all data quality checks
-- additional calculated columns are added to the cleaned data table for further analysis

DROP TABLE IF EXISTS hdb_resale_clean;

CREATE TABLE hdb_resale_clean AS
SELECT * FROM hdb_resale;

ALTER TABLE hdb_resale_clean
ADD COLUMN resale_date DATE,
ADD COLUMN resale_year INT,
ADD COLUMN resale_month INT,
ADD COLUMN price_per_sqm DECIMAL(12,2),
ADD COLUMN property_age INT;

-- converting into proper date 
UPDATE hdb_resale_clean 
SET resale_date = STR_TO_DATE(
CONCAT(`month`, '-01'),
'%Y-%m-%d');

-- 
UPDATE hdb_resale_clean 
SET 
resale_year = YEAR(resale_date),
resale_month = MONTH(resale_date),
price_per_sqm = ROUND((resale_price/floor_area_sqm),2),
property_age = YEAR(resale_date) - lease_commence_date;


SELECT * from hdb_resale_clean limit 10;

-- check
SELECT
    COUNT(*) AS total_rows,
    SUM(resale_date IS NULL) AS missing_resale_dates,
    SUM(price_per_sqm IS NULL) AS missing_price_per_sqm,
    SUM(property_age IS NULL) AS missing_property_age
FROM hdb_resale_clean;