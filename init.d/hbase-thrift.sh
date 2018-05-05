#!/bin/bash
sleep 15
exec /usr/bin/hbase thrift start -p ${HBASE_THRIFT_PORT} --infoport ${HBASE_THRIFT_INFOPORT}
