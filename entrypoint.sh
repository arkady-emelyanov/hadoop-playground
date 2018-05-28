#!/bin/bash
set -eo pipefail

. /etc/environment

# root: perform all actions we needed
mkdir -p "${HADOOP_PID_DIR}"
mkdir -p "${HADOOP_LOG_DIR}"

mkdir -p "${HADOOP_STORAGE_SDA1}"
mkdir -p "${HADOOP_STORAGE_SDA2}"

mkdir -p "${ZOOKEEPER_STORAGE_DIR}"
echo "${ZOOKEEPER_ID}" > "${ZOOKEEPER_STORAGE_DIR}/myid"

chown -R ${HADOOP_USER}:${HADOOP_USER} "${HADOOP_STORAGE_DIR}"

chown -R ${HADOOP_USER}:${HADOOP_USER} "${HADOOP_PID_DIR}"
chown -R ${HADOOP_USER}:${HADOOP_USER} "${HADOOP_LOG_DIR}"

chown -R ${HADOOP_USER}:${HADOOP_USER} "${HADOOP_STORAGE_SDA1}"
chown -R ${HADOOP_USER}:${HADOOP_USER} "${HADOOP_STORAGE_SDA2}"
chown -R ${HADOOP_USER}:${HADOOP_USER} "${ZOOKEEPER_STORAGE_DIR}"

exec /bin/supervisord -c /etc/supervisord.cfg
