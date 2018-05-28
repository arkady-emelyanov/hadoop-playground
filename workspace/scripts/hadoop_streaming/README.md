# HDFS streaming MapReduce

> hdfs3 library is already present in Docker image

## Useful links

* http://www.michael-noll.com/tutorials/writing-an-hadoop-mapreduce-program-in-python/
* http://www.tnoda.com/blog/2013-11-23
* http://hdfs3.readthedocs.io/en/latest/api.html

## Check it out

Enter hadoop console and change directory to test scripts:
```
$ ./console
$ cd /workspace/scripts/hadoop_streaming
```

Checking mapper and reducer with sample data:
```
$ ./run_sample.sh
altay:/tariffs/just_calls/	1
chukotka:/tariffs/just_calls/	1
komi:/go/sdd	2
komi:/internet/lte/	1
```

Generating full data set (approx 3.3GB):
```
$ ./generate.py
START DATE: 2018-05-05T00:00:00 
DAYS: 4
Generating ../../tmp/access_log0
Generating ../../tmp/access_log1
...
Done..
```

Upload data set to HDFS:
``` 
$ ./upload.py 
NameNode host: namenode1.cluster.local
NameNode port: 9000
Uploading ../../tmp/access_log0 => /hadoop_streaming/access_log0
Uploading ../../tmp/access_log1 => /hadoop_streaming/access_log1
...
Done..
```

Run MapReduce job:
```
$ ./run_streaming.sh 
packageJobJar: [/workspace/scripts/hadoop_streaming/mapper.py, /workspace/scripts/hadoop_streaming/reducer.py] [/usr/hdp/2.6.4.0-91/hadoop-mapreduce/hadoop-streaming-2.7.3.2.6.4.0-91.jar] /tmp/streamjob7839443007809965739.jar tmpDir=null
$ 
```

Check status:
```
$ mapred queue -info root -showJobs
======================
Queue Name : root 
Queue State : running 
Scheduling Info : Capacity: 100.0, MaximumCapacity: 100.0, CurrentCapacity: 12.5 
Total jobs:1
                  JobId	     State	     StartTime	    UserName	       Queue	  Priority	 UsedContainers	 RsvdContainers	 UsedMem	 RsvdMem	 NeededMem	   AM info
 job_1527527747392_0002	   RUNNING	 1527528218910	      hadoop	     default	    NORMAL	              2	              0	   3072M	      0M	     3072M	http://namenode1.cluster.local:8088/proxy/application_1527527747392_0002/
```


Wait.. and observe results:
```
$ hdfs dfs -ls /hadoop_streaming/out/
Found 2 items
-rw-r--r--   3 hadoop supergroup          0 2018-05-05 23:22 /hadoop_streaming/out/_SUCCESS
-rw-r--r--   3 hadoop supergroup       5614 2018-05-05 23:22 /hadoop_streaming/out/part-00000

$ hdfs dfs -cat /hadoop_streaming/out/part-00000 | head
altay:/	392636
altay:/ad/bonus	393252
altay:/ad/pay	394391
altay:/ad/wholeworld	393357
altay:/go/cinema	393559
altay:/go/recharge	392992
altay:/go/sdd	392554
altay:/internet/archive/	393891
altay:/internet/lte/	393412
altay:/internet/options/	394701
```

Great success!
