#!/bin/env python
# -*- coding: utf-8 -*-

import random
import os

random.seed(os.urandom(20))
DATE_START = 1525478400 # 2018-05-05T00:00:00 - 2018-05-08T02:59:59
DAYS = 4
RPS_MIN = 100
RPS_MAX = 300
RPS_STEP = 5
LFILE_FMT = '../../tmp/access_log'
RFILE_FMT = '/hadoop_streaming/access_log'
NAMENODE_HOST='namenode1.cluster.local'
NAMENODE_PORT=9000
