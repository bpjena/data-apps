
--step-2
GRANT CREATE APPLICATION PACKAGE ON ACCOUNT TO ROLE accountadmin;
CREATE APPLICATION PACKAGE real_estate_data_package;
USE APPLICATION PACKAGE real_estate_data_package;
CREATE OR REPLACE SCHEMA stage_content;
USE SCHEMA stage_content;
CREATE OR REPLACE STAGE real_estate_data_package.stage_content.real_estate_data_stage
  FILE_FORMAT = (TYPE = 'csv' FIELD_DELIMITER = '|' SKIP_HEADER = 1);

--step-3
-- need to create an local db and views so they can be shared with real_estate_data_package
CREATE DATABASE IF NOT EXISTS REAL_ESTATE_DATA;
CREATE VIEW IF NOT EXISTS ZRHVI2020JUL AS SELECT * FROM REAL_ESTATE_DATA_ATLAS.REALESTATE.ZRHVI2020JUL;
CREATE VIEW IF NOT EXISTS ZRRENTVI2020JUL AS SELECT * FROM REAL_ESTATE_DATA_ATLAS.REALESTATE.ZRRENTVI2020JUL;

-- give the app package reference access to a local db
GRANT REFERENCE_USAGE ON DATABASE REAL_ESTATE_DATA TO SHARE IN APPLICATION PACKAGE real_estate_data_package;

-- set the context to the application package
USE APPLICATION PACKAGE real_estate_data_package;

-- create schema shared_data and create tables for the data
CREATE SCHEMA IF NOT EXISTS shared_data;
USE SCHEMA shared_data;
CREATE TABLE IF NOT EXISTS ZRHVI2020JUL AS SELECT * FROM REAL_ESTATE_DATA.public.ZRHVI2020JUL;
CREATE TABLE IF NOT EXISTS ZRRENTVI2020JUL AS SELECT * FROM REAL_ESTATE_DATA.public.ZRRENTVI2020JUL;

-- grant app package usage access to shared_data (must have)
GRANT USAGE ON SCHEMA real_estate_data_package.shared_data TO SHARE IN APPLICATION PACKAGE real_estate_data_package;

-- grant select on tables to share in application package
GRANT SELECT ON TABLE real_estate_data_package.shared_data.ZRHVI2020JUL TO SHARE IN APPLICATION PACKAGE real_estate_data_package;
GRANT SELECT ON TABLE real_estate_data_package.shared_data.ZRRENTVI2020JUL TO SHARE IN APPLICATION PACKAGE real_estate_data_package;
GRANT SELECT ON TABLE real_estate_data_package.shared_data.COUNTY_CORR TO SHARE IN APPLICATION PACKAGE real_estate_data_package;

--step-6
-- drop application if it already exists
-- DROP APPLICATION real_estate_data_app;

-- create application
CREATE APPLICATION real_estate_data_app
  FROM APPLICATION PACKAGE real_estate_data_package
  USING '@real_estate_data_package.stage_content.real_estate_data_stage';

--step-7
-- add version to new app
ALTER APPLICATION PACKAGE real_estate_data_package
  ADD VERSION V1
  USING '@real_estate_data_package.stage_content.real_estate_data_stage';

-- set release directive
ALTER APPLICATION PACKAGE real_estate_data_package
  SET DEFAULT RELEASE DIRECTIVE
  VERSION = v1
  PATCH = 0;

-- Cybersyn dataset US Housing & Real Estate Essentials
-- get county level time trend of house prices vs demographics (ex income, etc)
CREATE OR REPLACE TABLE COUNTY_CORR AS
WITH county_map AS (
    SELECT
        geo_id,
        geo_name,
        related_geo_id,
        related_geo_name
    FROM CYBERSYN_US_HOUSING__REAL_ESTATE_ESSENTIALS.cybersyn.geography_relationships
    WHERE 1=1
    --AND geo_name = 'Phoenix-Mesa-Scottsdale, AZ Metro Area'
    AND related_level = 'County'
), gross_income_data AS (
    SELECT
        geo_id,
        geo_name AS msa,
        related_geo_name AS near_msa,
        date,
        SUM(value) AS gross_income_inflow
    FROM CYBERSYN_US_HOUSING__REAL_ESTATE_ESSENTIALS.cybersyn.irs_origin_destination_migration_timeseries AS ts
    JOIN county_map ON (county_map.related_geo_id = ts.to_geo_id)
    WHERE ts.variable_name = 'Adjusted Gross Income'
    GROUP BY geo_id, msa, near_msa, date
), home_price_data AS (
    SELECT LAST_DAY(date, 'year') AS end_date, AVG(value) AS home_price_index
    FROM CYBERSYN_US_HOUSING__REAL_ESTATE_ESSENTIALS.cybersyn.fhfa_house_price_timeseries AS ts
    JOIN CYBERSYN_US_HOUSING__REAL_ESTATE_ESSENTIALS.cybersyn.fhfa_house_price_attributes AS att
        ON (ts.variable = att.variable)
    WHERE geo_id IN (SELECT geo_id FROM county_map)
      AND att.index_type = 'purchase-only'
      AND att.seasonally_adjusted = TRUE
    GROUP BY end_date
)
SELECT
    msa,
    near_msa,
    gid.date,
    gross_income_inflow,
    home_price_index
FROM gross_income_data AS gid
JOIN home_price_data AS hpi ON (gid.date = hpi.end_date)
--where lower(near_msa) like 'san fra%'
ORDER BY 2, date;