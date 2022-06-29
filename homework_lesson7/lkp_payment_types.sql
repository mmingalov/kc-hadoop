use yellow_taxi;

drop table IF EXISTS lkp_payment_types;
-- 1= Credit card
-- 2= Cash
-- 3= No charge
-- 4= Dispute
-- 5= Unknown
-- 6= Voided trip
create table lkp_payment_types
(
    id int,
    name string
)
stored as parquet;

with t as (
    select 1, 'Credit card'
    union all
    select 2, 'Cash'
    union all
    select 3, 'No charge'
    union all
    select 4, 'Dispute'
    union all
    select 5, 'Unknown'
    union all
    select 6, 'Voided trip'
    )
insert into lkp_payment_types select * from t;