use yellow_taxi;
drop table IF EXISTS taxi_view_table;
--creating and filling VIEW TABLE
create table taxi_view_table
stored as parquet
as
select payment_type
    ,pickup_date
    ,tips_average_amount
    ,passengers_total
from taxi_view;

