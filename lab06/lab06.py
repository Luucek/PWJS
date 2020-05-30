#!/usr/bin/python

import sys
import os

if len(sys.argv) > 1:
    path = sys.argv[1]
else:
    path = "."

files = os.listdir(path)
files.sort()

for filename in files:
    print(filename)
