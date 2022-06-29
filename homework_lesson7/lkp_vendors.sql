use yellow_taxi;
drop table IF EXISTS lkp_vendors;
-- 1= Creative Mobile Technologies, LLC; 2= VeriFone Inc
create table lkp_vendors
(
    id int,
    name string
)
stored as parquet;

insert into lkp_vendors
select 1, 'Creative Mobile Technologies'
union all
select 2, 'VeriFone Inc';