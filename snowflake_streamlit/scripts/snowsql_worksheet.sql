
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