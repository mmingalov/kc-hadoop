use yellow_taxi;
-- First we will create a temporary external table, without partitions.
-- goal is to collect all data stored in 2020 directory
drop table IF EXISTS ext_tmp_table;
create external table ext_tmp_table
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
LOCATION '/user/root/2020/'
TBLPROPERTIES ("skip.header.line.count"="1");

--now we have to create new table and add new calculation column to it
-- we will use it for PARTITION at next step
drop table IF EXISTS tmp_table;
create table tmp_table as
select *,to_date(tpep_pickup_datetime) AS dt from ext_tmp_table;
select * from tmp_table limit 10;

--Next step: we create the actual table with partitions and load data from temporary table into partitioned table.
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
stored as parquet
TBLPROPERTIES ("skip.header.line.count"="1");


--FAILED: SemanticException [Error 10096]: Dynamic partition strict mode requires at least one static partition column.
--To turn this off set hive.exec.dynamic.partition.mode=nonstrict
set hive.exec.dynamic.partition.mode=nonstrict;

--Fatal error occurred when node tried to create too many dynamic partitions.
--The maximum number of dynamic partitions is controlled by hive.exec.max.dynamic.partitions and hive.exec.max.dynamic.partitions.pernode.
--Maximum was set to 100 partitions per node, number of dynamic partitions on this node: 101
SET hive.exec.max.dynamic.partitions=400;
SET hive.exec.max.dynamic.partitions.pernode=400;

insert into taxi_data PARTITION (dt)
select
    vendor_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    ratecode_id,
    store_and_fwd_flag,
    pulocation_id,
    dolocation_id,
    payment_type_id,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    dt
from tmp_table
where dt >= '2020-01-01' and dt<= '2020-12-31'; --use WHERE because data are not clean



