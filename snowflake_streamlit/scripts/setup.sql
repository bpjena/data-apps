-- ==========================================
-- This script runs when the app is installed
-- ==========================================

--  create an application role, similar to database roles, but they can only be used within the context of an application
CREATE APPLICATION ROLE IF NOT EXISTS APP_PUBLIC;

-- create a new versioned schema to be used for public objects
CREATE OR ALTER VERSIONED SCHEMA app_schema;
GRANT USAGE ON SCHEMA app_schema TO APPLICATION ROLE APP_PUBLIC;

-- use tables from the application package and create views in the app
CREATE OR REPLACE VIEW app_schema.ZRHVI2020JUL AS SELECT * FROM shared_data.ZRHVI2020JUL;
CREATE OR REPLACE VIEW app_schema.ZRRENTVI2020JUL AS SELECT * FROM shared_data.ZRRENTVI2020JUL;
CREATE OR REPLACE VIEW app_schema.COUNTY_CORR AS SELECT * FROM shared_data.COUNTY_CORR;

-- grant select on the views to APP_PUBLIC role so the consumer can access them
GRANT SELECT ON VIEW app_schema.ZRHVI2020JUL TO APPLICATION ROLE APP_PUBLIC;
GRANT SELECT ON VIEW app_schema.ZRRENTVI2020JUL TO APPLICATION ROLE APP_PUBLIC;
GRANT SELECT ON VIEW app_schema.COUNTY_CORR TO APPLICATION ROLE APP_PUBLIC;

-- add Streamlit object
CREATE OR REPLACE STREAMLIT app_schema.streamlit
  FROM '/streamlit'
  MAIN_FILE = '/real_estate.py'
;

-- grant APP_PUBLIC role to access the Streamlit object
GRANT USAGE ON STREAMLIT app_schema.streamlit TO APPLICATION ROLE APP_PUBLIC;