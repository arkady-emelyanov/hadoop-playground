#!/bin/bash

cat /workspace/scripts/hadoop_streaming/sample.txt | \
    /workspace/scripts/hadoop_streaming/mapper.py | \
    sort -k1,1 | \
    /workspace/scripts/hadoop_streaming/reducer.py
