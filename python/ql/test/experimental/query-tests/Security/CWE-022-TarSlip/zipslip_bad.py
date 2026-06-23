import tarfile
import shutil
import bz2
import gzip
import zipfile

def unzip(filename):
    with tarfile.open(filename) as zipf: # $ Alert[py/zipslip]
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.move(entry, "/tmp/unpack/") # $ Sink[py/zipslip]

def unzip1(filename):
    with gzip.open(filename) as zipf: # $ Alert[py/zipslip]
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.copy2(entry, "/tmp/unpack/") # $ Sink[py/zipslip]

def unzip2(filename):
    with bz2.open(filename) as zipf: # $ Alert[py/zipslip]
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.copyfile(entry, "/tmp/unpack/") # $ Sink[py/zipslip]

def unzip3(filename):
    zf = zipfile.ZipFile(filename)
    with zf.namelist() as filelist: # $ Alert[py/zipslip]
    #BAD : This could write any file on the filesystem.
        for x in filelist:
            shutil.copy(x, "/tmp/unpack/") # $ Sink[py/zipslip]

def unzip4(filename):
    zf = zipfile.ZipFile(filename)
    filelist = zf.namelist() # $ Alert[py/zipslip]
    for x in filelist:
        with zf.open(x) as srcf:
            shutil.copyfileobj(x, "/tmp/unpack/") # $ Sink[py/zipslip]

import tty # to set the import root so we can identify the standard library
