#!/bin/env python2
# -*- coding: utf-8 -*-

# <verb> <uri> <region> <date>
# GET /tariff/mobile moscow 2018-03-24T12:22:23

import sys
import os.path
import random
import datetime

import config

VERB = ['GET']
URI = [
    '/',
    # /internet
    '/internet/options/',
    '/internet/archive/',
    '/internet/lte/',
    # /tariffs
    '/tariffs/simple/',
    '/tariffs/just_calls/',
    '/tariffs/tablet/',
    '/tariffs/archive/'
    # other
    '/ad/autoextend',
    '/ad/pay',
    '/ad/wholeworld',
    '/ad/bonus',
    '/go/recharge',
    '/go/sdd',
    '/go/cinema',
]

REGION = [
    'moscow', 'spb', 'astrakhan', 'volga', 'chukotka',
    'krasnodar', 'dv', 'altay', 'belgorod', 'irkutsk',
    'kursk', 'magadan', 'omsk', 'komi'
]

print 'START DATE:', datetime.datetime.fromtimestamp(config.DATE_START).strftime('%Y-%m-%dT%H:%M:%S')
print 'DAYS:', config.DAYS

def write_requests(number, tt):
    dt = datetime.datetime.fromtimestamp(tt)
    for i in range(0, number):
        v = random.choice(VERB)
        u = random.choice(URI)
        r = random.choice(REGION)
        s = "%s %s %s %s\n" % (v, u, r, dt.strftime('%Y-%m-%dT%H:%M:%S'),)
        fh.write(s)

sec = 0
for day in range(0, config.DAYS):
    dst = "".join([config.LFILE_FMT, str(day)])
    if os.path.exists(dst):
        print 'Skipping', dst, 'generation, already exists..'
        continue

    print 'Generating', dst
    fh = open(dst, 'w+')
    day_sec = 0

    while day_sec < 86400:
        rps = random.randrange(config.RPS_MIN, config.RPS_MAX, config.RPS_STEP)
        write_requests(rps, config.DATE_START + sec)
        day_sec += 1

    sec += day_sec
    fh.close()

print 'Done..'
