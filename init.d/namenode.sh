#!/bin/bash
set -eo pipefail

# first time start, namenode should be formatted
if [ ! -f "${HADOOP_STORAGE_DIR}/.done" ]; then
    /usr/bin/hdfs namenode -format && touch "${HADOOP_STORAGE_DIR}/.done"
fi

exec /usr/bin/hdfs namenode
