-- check the data
SELECT * from hdb_resale 
LIMIT 10;

-- check table structure 
DESCRIBE hdb_resale;

-- check total rows and missing values
SELECT
    COUNT(*) AS total_records,
    SUM(`month` IS NULL) AS missing_month,
    SUM(town IS NULL) AS missing_town,
    SUM(flat_type IS NULL) AS missing_flat_type,
    SUM(resale_price IS NULL) AS missing_resale_price
FROM hdb_resale;

-- check duplicates
-- since there are no unique IDs, all columns are used for duplicate check
-- retaining as duplicates may be valid in this case as there can be multiple transactions for the same flat in a month
SELECT
    `month`,
    town,
    flat_type,
    block,
    street_name,
    storey_range,
    floor_area_sqm,
    flat_model,
    lease_commence_date,
    remaining_lease,
    resale_price,
    COUNT(*) AS duplicate_count
FROM hdb_resale
GROUP BY
    `month`,
    town,
    flat_type,
    block,
    street_name,
    storey_range,
    floor_area_sqm,
    flat_model,
    lease_commence_date,
    remaining_lease,
    resale_price
HAVING COUNT(*) > 1;

-- check missing values
-- trim for removing whitespace
SELECT
    SUM(`month` IS NULL OR TRIM(`month`) = '') AS missing_month,
    SUM(town IS NULL OR TRIM(town) = '') AS missing_town,
    SUM(flat_type IS NULL OR TRIM(flat_type) = '') AS missing_flat_type,
    SUM(block IS NULL OR TRIM(block) = '') AS missing_block,
    SUM(street_name IS NULL OR TRIM(street_name) = '') AS missing_street,
    SUM(storey_range IS NULL OR TRIM(storey_range) = '') AS missing_storey,
    SUM(floor_area_sqm IS NULL) AS missing_floor_area,
    SUM(flat_model IS NULL OR TRIM(flat_model) = '') AS missing_flat_model,
    SUM(lease_commence_date IS NULL) AS missing_lease_date,
    SUM(remaining_lease IS NULL OR TRIM(remaining_lease) = '') AS missing_remaining_lease,
    SUM(resale_price IS NULL) AS missing_resale_price
FROM hdb_resale;

-- check any inconsistent columns 
SELECT DISTINCT town, flat_type, block, street_name, storey_range, flat_model
FROM hdb_resale
WHERE town <> TRIM(town) OR 
flat_type <> TRIM(flat_type) OR
block <> TRIM(block) OR
street_name <> TRIM(street_name) OR
storey_range <> TRIM(storey_range) OR
flat_model <> TRIM(flat_model);

-- check invalid numeric values
SELECT *
FROM hdb_resale
WHERE
    floor_area_sqm <= 0
    OR resale_price <= 0
    OR lease_commence_date <= 0;

-- check lease dates
SELECT MIN(lease_commence_date), MAX(lease_commence_date)
FROM hdb_resale;

-- check min max numeric values
SELECT MIN(resale_price), MAX(resale_price), MIN(floor_area_sqm), MAX(floor_area_sqm)
FROM hdb_resale;

-- check distinct values
SELECT DISTINCT `month`
FROM hdb_resale
ORDER BY `month`;

SELECT DISTINCT flat_type
FROM hdb_resale
ORDER BY flat_type;

SELECT DISTINCT town 
FROM hdb_resale 
ORDER BY town;

SELECT DISTINCT flat_model 
FROM hdb_resale 
ORDER BY flat_model;

SELECT DISTINCT storey_range 
FROM hdb_resale 
ORDER BY storey_range;