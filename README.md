# Hadoop Cluster Playground

Yet another Hadoop Cluster playground (`HDP v2.6.4`)

## Requirements

* RAM: 16GB+
* CPU cores: 8+
* Any modern x86_64 Linux distro (CentOS 7 in my case)
* docker >= `18.03.1-ce`
* docker-compose >= `1.21.0`

## Let's start

Put entries to `/etc/hosts`
```
10.5.0.11 namenode1 namenode1.cluster.local
10.5.0.12 namenode2 namenode2.cluster.local
10.5.0.21 datanode1 datanode1.cluster.local
10.5.0.22 datanode2 datanode2.cluster.local
10.5.0.23 datanode3 datanode3.cluster.local
```

Build and start cluster:
```bash
$ docker-compose build
$ docker-compose up
```

Web-UI endpoints:
* Hadoop Cluster UI: http://namenode1.cluster.local:8088/
* Namenode UI: http://namenode1.cluster.local:50070/
* Thrift Server UI: http://namenode1.cluster.local:6121/

API endpoints:
* Thrift Server: `namenode1.cluster.local:6120`

Jump into console of `hadoop` user
```bash
$ ./console
```

Try some sample commands:
```bash
$ hadoop fs -ls /
$ yarn node -list -all
```

Run bundled MapReduce:
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

Check HBase cluster status:
```
$ hbase shell
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 1.1.2.2.6.4.0-91, r2a88e694af7238290a5747f963a4fa0079c55bf9, Thu Jan  4 10:42:39 UTC 2018
 
hbase(main):001:0> status
1 active master, 1 backup masters, 3 servers, 0 dead, 0.6667 average load
```

## Python examples

* [hdfs, streaming and mapreduce](./workspace/scripts/hdfs_streaming)
* [hbase, pig and mapreduce](./workspace/scripts/hbase_pig)


## Services Layout

> Service order is mandatory, in case of exceptions,
try to play with sleep values in init.d scripts.

NameNode (primary)
* ssh
* zookeeper
* namenode (hdfs)
* resourcemanager (yarn)
* hbase-master (hbase)
* hbase-thrift (hbase)

NameNode (secondary)
* ssh
* zookeeper
* secondarynamenode (hdfs)
* resourcemanager (yarn)
* hbase-master (hbase)

DataNode (1..3)
* ssh
* zookeeper
* datanode (hdfs)
* nodemanager (yarn)
* hbase-regionserver (hbase)
