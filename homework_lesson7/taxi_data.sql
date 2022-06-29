use yellow_taxi;
-- First we will create a temporary external table, without partitions.
drop table IF EXISTS tmp_table;
create external table tmp_table
(
    vendor_id string,
    tpep_pickup_datetime timestamp,
    tpep_dropoff_datetime timestamp,
    passenger_count int,
    trip_distance double,
    ratecode_id int,
    store_and_fwd_flag string,
    pulocation_id int,
    dolocation_id int,
    payment_type_id int,
    fare_amount double,
    extra double,
    mta_tax double,
    tip_amount double,
    tolls_amount double,
    improvement_surcharge double,
    total_amount double,
    congestion_surcharge double
)
row format delimited
fields terminated by ','
lines terminated by '\n'
LOCATION ('/2020/')
TBLPROPERTIES ("skip.header.line.count"="1");

--now we have to add new column and fill it by values. We will use it for partition foal on next step.
alter table tmp_table
add column dt date;

update tmp_table
set dt = to_date(tpep_pickup_datetime);

--Next, we create the actual table with partitions and load data from temporary table into partitioned table.
drop table IF EXISTS taxi_data;
create table taxi_data
(
    vendor_id string,
    tpep_pickup_datetime timestamp,
    tpep_dropoff_datetime timestamp,
    passenger_count int,
    trip_distance double,
    ratecode_id int,
    store_and_fwd_flag string,
    pulocation_id int,
    dolocation_id int,
    payment_type_id int,
    fare_amount double,
    extra double,
    mta_tax double,
    tip_amount double,
    tolls_amount double,
    improvement_surcharge double,
    total_amount double,
    congestion_surcharge double
)
partitioned by (dt date)
row format delimited
fields terminated by ','
lines terminated by '\n'
TBLPROPERTIES ("skip.header.line.count"="1");

INSERT OVERWRITE TABLE taxi_data PARTITION (dt)
select t.*
from tmp_table t;