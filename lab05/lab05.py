#!/usr/bin/python

import sys
import os
import filecmp

class MyFile:
    path = ""
    size = 1
    duplicated = False

    def __init__(self, path, size):
        self.path = path
        self.size = size


def sizeExist(files, size):
    for file in files:
        if file.size == size:
            file.duplicated = True
            return True
    return False


def displayDuplicats(files):
    print("Duplicates:")
    for file in files:
        if file.duplicated == True:
            print(file.path)


def isDuplicated(files, path):
    for file in files:
        if file.duplicated == True:
            if filecmp.cmp(file.path, path):
                return True
            else:
                file.duplicated = False
    return False


args = sys.argv
args = args[1:]

files = []

for dir in args:
    for filename in os.listdir(dir):
        path = dir + '/' + filename
        if os.path.isfile(path):
            size = os.path.getsize(path)
            file = MyFile(path, size)
            if sizeExist(files, size) == False:
                files.append(file)
            else:
                if isDuplicated(files, path):
                    file.duplicated = True
                files.append(file)

displayDuplicats(files)
