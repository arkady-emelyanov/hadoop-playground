#!/bin/bash

INPUT_MASK='/hadoop_streaming/access_log*'
OUTPUT_DIR='/hadoop_streaming/out'

hdfs dfs -rm -r -f ${OUTPUT_DIR} || /bin/true
yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar \
    -background \
    -file /workspace/scripts/hadoop_streaming/mapper.py \
    -file /workspace/scripts/hadoop_streaming/reducer.py \
    -mapper /workspace/scripts/hadoop_streaming/mapper.py \
    -reducer /workspace/scripts/hadoop_streaming/reducer.py \
    -input ${INPUT_MASK} \
    -output ${OUTPUT_DIR}
