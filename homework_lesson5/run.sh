#copying data from s3 to our cluster using `distcp`
hadoop fs -mkdir 2020
hadoop distcp \
-Dfs.s3a.endpoint=s3.amazonaws.com \
-Dfs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.AnonymousAWSCredentialsProvider \
s3a://nyc-tlc/csv_backup/yellow_tripdata_2020* 2020/

#checking content
hadoop fs -text 2020/yellow_tripdata_2020-10.csv | head -n 10



export MR_OUTPUT=/user/root/output-data
hadoop fs -rm -r $MR_OUTPUT

hadoop jar "$HADOOP_MAPRED_HOME"/hadoop-streaming.jar \
-Dmapred.job.name='REPORT -- Tips average amount by Months and Payment types' \
-Dmapred.reduce.tasks=1 \
-file /tmp/mapreduce/mapper.py -mapper /tmp/mapreduce/mapper.py \
-file /tmp/mapreduce/reducer.py -reducer /tmp/mapreduce/reducer.py \
-input /user/root/2020 -output $MR_OUTPUT

hadoop fs -text output-data/part-00000

# -Dmapred.reduce.tasks=1 \
#-Dmapreduce.input.lineinputformat.linespermap=1000 \
#-inputformat org.apache.hadoop.mapred.lib.NLineInputFormat \


#-Dmapred.job.name='Simple streaming job' \
#-Dmapred.reduce.tasks=1 -Dmapreduce.input.lineinputformat.linespermap=1000 \
#-inputformat org.apache.hadoop.mapred.lib.NLineInputFormat \


# -inputformat org.apache.hadoop.mapred.lib.NLineInputFormat -Dmapreduce.input.lineinputformat.linespermap=1000 \

## s3
# -Dfs.s3a.endpoint=s3.amazonaws.com -Dfs.s3a.aws.credentials.provider=org.apache.hadoop.fs.s3a.AnonymousAWSCredentialsProvider


#hadoop fs -rm -r taxi-output
#
#hadoop jar "$HADOOP_MAPRED_HOME"/hadoop-streaming.jar \
#-Dmapred.job.name='Taxi streaming job' \
#-Dmapred.reduce.tasks=10 \
#-Dmapreduce.map.memory.mb=1024 \
#-file /tmp/mapreduce/mapper.py -mapper /tmp/mapreduce/mapper.py \
#-file /tmp/mapreduce/reducer.py -reducer /tmp/mapreduce/reducer.py \
#-input /user/root/2019  -output taxi-output
