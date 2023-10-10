-- CITIBIKE datasets in Snowflake
-- source: https://citibikenyc.com/system-data

--step 0: database & schema
create database st_loader

create schema st_loader.uploads
create schema st_loader.citibike

--step 1: create stage object & file format
create or replace file format st_loader.citibike.csv_trips type='csv'
  compression = 'auto' field_delimiter = ',' record_delimiter = '\n'
  skip_header = 0 field_optionally_enclosed_by = '\042' trim_space = false
  error_on_column_count_mismatch = false escape = 'none' escape_unenclosed_field = '\134'
  date_format = 'auto' timestamp_format = 'auto' null_if = ('') comment = 'file format for ingesting citibike ';

--step 2 : create table TRIPS
create or replace table st_loader.citibike.trips
(tripduration integer,
starttime timestamp,
stoptime timestamp,
start_station_id integer,
start_station_name string,
start_station_latitude float,
start_station_longitude float,
end_station_id integer,
end_station_name string,
end_station_latitude float,
end_station_longitude float,
bikeid integer,
membership_type string,
usertype string,
birth_year integer,
gender integer);

--step 2.1 : copy from stage into table created
copy into st_loader.citibike.trips
from @citibike_trips
file_format=csv_trips;

--step 3 : file structure i.e. columns changed in source
create or replace table st_loader.citibike.trips_new_format
(
ride_id string
, rideable_type string
, started_at string
, ended_at string
, start_station_name string
, start_station_id float
, end_station_name string
, end_station_id  float
, start_lat float
, start_lng float
, end_lat float
, end_lng float
, member_casual string
)
--manually loaded csv into the table.
--NOTE: column made as string due to source data format
--transformed view has the correct datatype and values
create or replace view trips_new as
SELECT
ride_id
, rideable_type
, TO_TIMESTAMP_NTZ(started_at, 'mm/dd/yy hh24:mi') AS started_at
, TO_TIMESTAMP_NTZ(ended_at, 'mm/dd/yy hh24:mi') AS ended_at
, start_station_name
, start_station_id
, end_station_name
, end_station_id
, start_lat
, start_lng
, end_lat
, end_lng
, member_casual
FROM TRIPS_NEW_FORMAT;
