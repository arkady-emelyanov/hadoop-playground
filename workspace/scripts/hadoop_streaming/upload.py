#!/bin/env python
# -*- coding: utf-8 -*-


import os.path
from hdfs3 import HDFileSystem
import config

print 'NameNode host:', config.NAMENODE_HOST
print 'NameNode port:', config.NAMENODE_PORT

client = HDFileSystem(host=config.NAMENODE_HOST, port=config.NAMENODE_PORT)
remote_dir = os.path.dirname(config.RFILE_FMT)
if not client.exists(remote_dir):
    client.mkdir(remote_dir)

for day in range(0, config.DAYS):
    src = "".join([config.LFILE_FMT, str(day)])
    dst = "".join([config.RFILE_FMT, str(day)])

    if not os.path.exists(src):
        print 'Skipping:', src, 'file not found!'
        continue

    if client.exists(dst):
        print 'Skipping:', dst, 'file already exists: hadoop fs -rm', dst
        continue

    print 'Uploading', src, '=>', dst
    client.put(src, dst)

print 'Done..'
