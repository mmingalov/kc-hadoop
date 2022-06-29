# MapReduce

## Preparing

1. to create S3 bucket (Object Storage)
2. to copy yellow taxi data for 2020 into s3 bucket

## Task
1. to create DB "yellow_taxi"

2. to create lookup tables according data description document (format — parquet) with columns id and name.

3. to create table of facts of taxi rides:

partition by day of starting the ride
columns names should be "underscore" (vendor_id, payment_type_id и т.д.)
store format — parquet. 
4. to create view taxi_view

5. to create table-view:

| Payment type | Date       | Tips average amount | Passengers total |
|--------------|------------|---------------------|------------------|
| Cash         | 2020-01-31 | 999.99              | 112              |

6. to insert data from view (#4) into table-view (#5) 

### Requirements to scripts

- names of scripts based on table/view names;
- run.sh, for launching all scripts

### Archive must include next scripts:

script for creating lookup tables;
script for creating table of facts;
script for filling table of facts;
script for creating view;
script for creating table-view;
script for inserting data into table-view;

script for launching all above in correct order
