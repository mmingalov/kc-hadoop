use yellow_taxi;
drop table IF EXISTS lkp_rates;
-- 1= Standard rate
-- 2=JFK
-- 3=Newark
-- 4=Nassau or Westchester
-- 5=Negotiated fare
-- 6=Group ride

create table lkp_rates
(
    id int,
    name string
)
stored as parquet;

insert into lkp_rates
select 1, 'Standard rate'
union all
select 2, 'JFK'
union all
select 3, 'Newark'
union all
select 4, 'Nassau or Westchester'
union all
select 5, 'Negotiated fare'
union all
select 6, 'Group ride';