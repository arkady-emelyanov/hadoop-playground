# Hadoop Cluster Playground

Yet another Hadoop Cluster playground (`HDP v3.6.4`).

```bash
$ docker-compose build
$ docker-compose up
```

```bash
$ docker-compose exec namenode1 /bin/bash
$ su - hadoop
```

Try sample commands (should be executed under `hadoop` user):
```bash
$ hadoop fs -ls /
$ hdfs fsck /
$ yarn node -list -all
$ yarn application -list
```

Validate Yarn MapReduce
```
$ yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar pi 16 1000
Number of Maps  = 16
Samples per Map = 1000
Wrote input for Map #0
Wrote input for Map #1
Wrote input for Map #2
Wrote input for Map #3
Wrote input for Map #4
Wrote input for Map #5
Wrote input for Map #6
Wrote input for Map #7
Wrote input for Map #8
Wrote input for Map #9
Wrote input for Map #10
Wrote input for Map #11
Wrote input for Map #12
Wrote input for Map #13
Wrote input for Map #14
Wrote input for Map #15
Starting Job
Job Finished in 32.566 seconds
Estimated value of Pi is 3.14250000000000000000
```

## Nodes and Services

NameNode (primary)
* ssh
* zookeeper
* namenode (hdfs)
* resourcemanager (yarn)

NameNode (secondary)
* ssh
* zookeeper
* namenode (hdfs)
* resourcemanager (yarn)

DataNode (1..3)
* ssh
* zookeeper
* datanode (hdfs)
* nodemanager (yarn)
