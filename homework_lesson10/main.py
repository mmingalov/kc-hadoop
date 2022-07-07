import os
from pathlib import Path

from pyspark.sql import SparkSession, DataFrame
from pyspark.sql import functions as f
from pyspark.sql.types import StructType, StructField, StringType, TimestampType, IntegerType, DoubleType

# MySql
MYSQL_HOST = 'rc1b-ydeux5kq8q0rruld.mdb.yandexcloud.net'
MYSQL_PORT = 3306
MYSQL_DATABASE = 'mysqldb'
MYSQL_TABLE = 'yt2020'
MYSQL_USER = 'spark'
MYSQL_PASSWORD = 'sparkspark'

# поля справочника
dim_columns = ['id', 'name']

vendor_rows = [
    (1, 'Creative Mobile Technologies, LLC'),
    (2, 'VeriFone Inc'),
]

rates_rows = [
    (1, 'Standard rate'),
    (2, 'JFK'),
    (3, 'Newark'),
    (4, 'Nassau or Westchester'),
    (5, 'Negotiated fare'),
    (6, 'Group ride'),
]

payment_rows = [
    (1, 'Credit card'),
    (2, 'Cash'),
    (3, 'No charge'),
    (4, 'Dispute'),
    (5, 'Unknown'),
    (6, 'Voided trip'),
]

trips_schema = StructType([
    StructField('vendor_id', StringType(), True),
    StructField('tpep_pickup_datetime', TimestampType(), True),
    StructField('tpep_dropoff_datetime', TimestampType(), True),
    StructField('passenger_count', IntegerType(), True),
    StructField('trip_distance', DoubleType(), True),
    StructField('ratecode_id', IntegerType(), True),
    StructField('store_and_fwd_flag', StringType(), True),
    StructField('pulocation_id', IntegerType(), True),
    StructField('dolocation_id', IntegerType(), True),
    StructField('payment_type', IntegerType(), True),
    StructField('fare_amount', DoubleType(), True),
    StructField('extra', DoubleType(), True),
    StructField('mta_tax', DoubleType(), True),
    StructField('tip_amount', DoubleType(), True),
    StructField('tolls_amount', DoubleType(), True),
    StructField('improvement_surcharge', DoubleType(), True),
    StructField('total_amount', DoubleType(), True),
    StructField('congestion_surcharge', DoubleType()),
])


def agg_calc(spark: SparkSession) -> DataFrame:
    data_path = os.path.join(Path(__name__).parent, 'c:\\temp\\', '2020_Yellow_Taxi_Trip_Data.csv')
    #'./homework_lesson10/data', '*.csv')

    trip_fact = spark.read \
        .option("header", "true") \
        .schema(trips_schema) \
        .csv(data_path)

    # avg_trip_cost = avg(total_amount)
    # trip_km_cost = avg(total_amount/trip_distance)
    # where trip_distance -- The elapsed trip distance in miles reported by the taximeter

    datamart = trip_fact \
        .where(
            (trip_fact['trip_distance'] != 0) &
            (f.to_date(trip_fact['tpep_pickup_datetime']) >= '2020-01-01') &
            (f.to_date(trip_fact['tpep_pickup_datetime']) <= '2020-12-31')
        )  \
        .groupBy(trip_fact['payment_type'],
                 f.to_date(trip_fact['tpep_pickup_datetime']).alias('Date')
                 ) \
        .agg(
            f.avg(trip_fact['total_amount']).alias('avg_trip_cost'),
            f.avg(trip_fact['total_amount']/(1.60934*trip_fact['trip_distance'])).alias("avg_trip_km_cost")
            ) \
        .select(f.col('Date'),
                f.col('payment_type'),
                f.col('avg_trip_cost'),
                f.col('avg_trip_km_cost')) \
        .orderBy(f.col('Date').desc(), f.col('payment_type'))

    return datamart


def create_dict(spark: SparkSession, header: list[str], data: list):
    """создание словаря"""
    df = spark.createDataFrame(data=data, schema=header)
    return df


def save_to_mysql(host: str, port: int, db_name: str, username: str, password: str, df: DataFrame, table_name: str):
    props = {
        'user': f'{username}',
        'password': f'{password}',
        'driver': 'com.mysql.cj.jdbc.Driver',
        "ssl": "true",
        "sslmode": "none",
    }

    df.write.mode("append").jdbc(
        url=f'jdbc:mysql://{host}:{port}/{db_name}',
        table=table_name,
        properties=props)


def main(spark: SparkSession):
    vendor_dim = create_dict(spark, dim_columns, vendor_rows)
    payment_dim = create_dict(spark, dim_columns, payment_rows)
    rates_dim = create_dict(spark, dim_columns, rates_rows)

    datamart = agg_calc(spark).cache()
    datamart.show(truncate=False, n=100)

    joined_datamart = datamart \
        .join(other=payment_dim, on=payment_dim['id'] == f.col('payment_type'), how='inner') \
        .select(f.col('Date'),
                payment_dim['name'].alias('payment_type'),
                f.col('avg_trip_cost'), f.col('avg_trip_km_cost')
                )

    # joined_datamart.show(truncate=False, n=100000)

    # joined_datamart.write.mode('overwrite').csv('output')



    save_to_mysql(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        db_name=MYSQL_DATABASE,
        username=MYSQL_USER,
        password=MYSQL_PASSWORD,
        df=joined_datamart,
        table_name=f'{MYSQL_DATABASE}.{MYSQL_TABLE}'
    )

    print('end')


if __name__ == '__main__':
    main(SparkSession
         .builder
         .config("spark.jars", "./jars/mysql-connector-java-8.0.25.jar")
         .appName('My first spark job')
         .getOrCreate())

# .config("spark.jars", "./practice4/jars/mysql-connector-java-8.0.25.jar")
