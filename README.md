# Hadoop playground

Yet another Hadoop playground (`HDP v2.6.4`)

## Requirements

* OS: `Linux x86_64`
* RAM: `16GB+`
* CPU cores: `8+`
* HDD: best results with `SSD`
* docker >= `18.03.1-ce`
* docker-compose >= `1.21.0`

## Configuration

Cluster is already pre-configured.

## Booting up

Add following records to `/etc/hosts` on host machine:
```
10.5.0.11 namenode1 namenode1.cluster.local
10.5.0.12 namenode2 namenode2.cluster.local
10.5.0.21 datanode1 datanode1.cluster.local
10.5.0.22 datanode2 datanode2.cluster.local
10.5.0.23 datanode3 datanode3.cluster.local
```

Build and boot up:
```bash
$ docker-compose build
$ docker-compose up
```

> Depending on CPU/RAM/SSD, cluster initialization could take some time. 


## Cluster Layout

| NameNode                     | namenode1.cluster.local  |
| ---------------------------- | ------------------------ |
| ssh                          |                          |
| zookeeper                    |                          |
| namenode                     | HDFS                     |
| resourcemanager              | Yarn                     |
| hbase-master                 | HBase                    |
| hbase-thrift                 | HBase Thrift API         |


| SecondaryNameNode            | namenode2.cluster.local  |
| ---------------------------- | ------------------------ |
| ssh                          |                          |
| zookeeper                    |                          |
| secondarynamenode            | HDFS                     |
| resourcemanager              | Yarn                     |
| hbase-master                 | HBase                    |


| DataNodes (1..3)             | datanodeX.cluster.local  |
| ---------------------------- | ------------------------ |
| ssh                          |                          |
| zookeeper                    |                          |
| datanode                     | HDFS                     |
| nodemanager                  | Yarn                     |
| hbase-regionserver           | HBase                    |


## Command line interface

There are pre-configured command line console, run `./console` and type
some Hadoop commands. To reach any other cluster node, use `ssh`.

## Validation

Check HDFS and Yarn reports:
```
$ hdfs dfsadmin -report
$ yarn node -list -all
```

Check HBase status:
```
$ hbase shell
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 1.1.2.2.6.4.0-91, r2a88e694af7238290a5747f963a4fa0079c55bf9, Thu Jan  4 10:42:39 UTC 2018
 
hbase(main):001:0> status
1 active master, 1 backup masters, 3 servers, 0 dead, 0.6667 average load
```

Submit sample MapReduce job:
```
$ yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar pi 16 1000
Number of Maps  = 16
Samples per Map = 1000
Wrote input for Map #0
...
Wrote input for Map #15
Starting Job
Job Finished in 32.566 seconds
Estimated value of Pi is 3.14250000000000000000
```

## Useful endpoints

* Hadoop: http://namenode1.cluster.local:8088/
* Namenode: http://namenode1.cluster.local:50070/
* Thrift: http://namenode1.cluster.local:6121/

## Python examples

* [MapReduce streaming](workspace/scripts/hadoop_streaming)
* More coming...
