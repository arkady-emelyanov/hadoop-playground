# HDFS streaming MapReduce

Enter hadoop console and change directory to test scripts:
```
$ ./console
$ cd /workspace/scripts/hdfs_streaming
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
hdp:/workspace/scripts/hdfs$ ./generate.py
START DATE: 2018-05-05T00:00:00 
DAYS: 3
Generating ../../tmp/access_log0
Generating ../../tmp/access_log1
Generating ../../tmp/access_log2
Done..
```

Upload data set to HDFS:
``` 
$ ./upload.py 
NameNode host: namenode1.cluster.local
NameNode port: 9000
Uploading ../../tmp/access_log0 => /streaming_test/access_log0
Uploading ../../tmp/access_log1 => /streaming_test/access_log1
Uploading ../../tmp/access_log2 => /streaming_test/access_log2
Done..
```

Run MapReduce job:
```
$ ./run_streaming.sh 
packageJobJar: [/workspace/scripts/hdfs_streaming/mapper.py, /workspace/scripts/hdfs_streaming/reducer.py] [/usr/hdp/2.6.4.0-91/hadoop-mapreduce/hadoop-streaming-2.7.3.2.6.4.0-91.jar] /tmp/streamjob7839443007809965739.jar tmpDir=null
```

Wait.. and observe results:
```
$ hadoop fs -ls /streaming_test/out/
Found 2 items
-rw-r--r--   3 hadoop supergroup          0 2018-05-05 23:22 /streaming_test/out/_SUCCESS
-rw-r--r--   3 hadoop supergroup       5614 2018-05-05 23:22 /streaming_test/out/part-00000

$ hadoop fs -cat /streaming_test/out/part-00000 | head
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
