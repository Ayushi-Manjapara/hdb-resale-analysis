# HDB Resale Price Analysis

## Project Overview
This project explores Singapore HDB resale transactions from
January 2017 to November 2026.

The analysis examines price trends, differences between towns,
and how prices vary by property age and storey range.

## Tools Used
- Exce, MySQL 

## Data source
https://data.gov.sg/datasets?topics=housing&resultId=d_8b84c4ee58e3cfc0ece0d773c8ca6abc

## Data Preparation
- Duplicates and nulls were removed in Excel before loading the data to SQL.
- Created a database and raw data table.
- Checked missing values, potential duplicates, numeric values,
  whitespace, and categories.
- Preserved the raw table and created a separate analysis table.
- Added resale date, year, month, price per sqm, and approximate
  property age.

## How to Reproduce
1. Use the CSV file in data/.
2. Run sql_analysis/1_database_setup.sql.
3. Import the CSV into the hdb_resale table using [your method].
4. Run sql_analysis/2_data_quality_check.sql.
5. Run sql_analysis/3_data_cleaning.sql.
6. Run sql_analysis/4_exploratory_analysis.sql.
