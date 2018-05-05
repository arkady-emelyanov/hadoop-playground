#!/bin/env python
# -*- coding: utf-8 -*-

import sys

for line in sys.stdin:
    parts = line.strip().split()
    if len(parts) != 4:
        print parts
        sys.exit(1)

    # TODO: check date
    # TODO: check verb
    print '%s:%s\t%s' % (parts[2], parts[1], 1)
