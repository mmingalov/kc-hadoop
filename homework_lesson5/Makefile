#copying our code to cluster
copy:
	scp ./*.py root@51.250.48.241:/tmp/mapreduce/ && scp ./run.sh root@51.250.48.241:/tmp/mapreduce/

#launching Job throws error everytime
#after research the problem I fixed it
#https://stackoverflow.com/questions/43048654/hadoop-python-subprocess-failed-with-code-127
#Row Delimeter should be set as LF
#or you can use these commands
sed -i -e 's/\r$//' /tmp/mapreduce/reducer.py
sed -i -e 's/\r$//' /tmp/mapreduce/mapper.py

#after these commands launching SUCCEEDED