#!/bin/bash

yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar \
    -file /workspace/scripts/hdfs_streaming/mapper.py \
    -mapper /workspace/scripts/hdfs_streaming/mapper.py \
    -file /workspace/scripts/hdfs_streaming/reducer.py \
    -reducer /workspace/scripts/hdfs_streaming/reducer.py \
    -input /streaming_test/access_log* \
    -output /streaming_test/out
