CREATE DATABASE hdb_analysis;

USE hdb_analysis;

CREATE TABLE hdb_resale (
    `month` VARCHAR(7),
    town VARCHAR(50),
    flat_type VARCHAR(20),
    block VARCHAR(20),
    street_name VARCHAR(100),
    storey_range VARCHAR(20),
    floor_area_sqm DECIMAL(8,2),
    flat_model VARCHAR(50),
    lease_commence_date INT,
    remaining_lease VARCHAR(50),
    resale_price DECIMAL(12,2)
);