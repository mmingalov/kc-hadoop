use yellow_taxi;

--creating VIEW
drop view IF EXISTS taxi_view;
create view taxi_view as
select
    p.name AS payment_type
    ,to_date(t.tpep_pickup_datetime) AS pickup_date
    ,avg(t.tip_amount) AS tips_average_amount
    ,sum(t.passenger_count) AS passengers_total
from taxi_data t join lkp_payment_types p on (t.payment_type_id = p.id)
group by p.name,to_date(t.tpep_pickup_datetime);