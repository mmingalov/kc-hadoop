copy:
	scp ./*.py root@84.201.187.68:/tmp/mapreduce/ && scp ./run.sh root@84.201.187.68:/tmp/mapreduce/

#launching Job throws error everytime
#after research the problem I fixed it
#https://stackoverflow.com/questions/43048654/hadoop-python-subprocess-failed-with-code-127

sed -i -e 's/\r$//' /tmp/mapreduce/reducer.py
sed -i -e 's/\r$//' /tmp/mapreduce/mapper.py

#after these commands launching SUCCEEDED