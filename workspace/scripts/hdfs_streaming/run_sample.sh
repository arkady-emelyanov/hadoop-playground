#!/bin/bash

cat /workspace/scripts/hdfs_streaming/sample.txt | \
    /workspace/scripts/hdfs_streaming/mapper.py | \
    sort -k1,1 | \
    /workspace/scripts/hdfs_streaming/reducer.py
