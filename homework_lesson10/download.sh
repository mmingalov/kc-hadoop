#copying data from s3 to our cluster using `distcp`
hadoop fs -mkdir 2020
hadoop distcp \
-Dfs.s3a.endpoint=s3.amazonaws.com \
-Dfs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.AnonymousAWSCredentialsProvider \
s3a://nyc-tlc/csv_backup/yellow_tripdata_2020* 2020/

#checking content
hadoop fs -text 2020/yellow_tripdata_2020-10.csv | head -n 10

# Что почитать
# https://hadoop.apache.org/docs/stable/hadoop-aws/tools/hadoop-aws/index.html
# https://registry.opendata.aws/nyc-tlc-trip-records-pds/