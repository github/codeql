import tarfile
import shutil
import bz2 
import gzip
import zipfile

def unzip(filename):
    with tarfile.open(filename) as zipf:
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.move(entry, "/tmp/unpack/")

def unzip1(filename):
    with gzip.open(filename) as zipf:
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.copy2(entry, "/tmp/unpack/")

def unzip2(filename):
    with bz2.open(filename) as zipf:
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.copyfile(entry, "/tmp/unpack/")

def unzip3(filename):
    zf = zipfile.ZipFile(filename) 
    filelist = zf.namelist()
    #BAD : This could write any file on the filesystem.
    for filename in filelist:
            shutil.copy(entry, "/tmp/unpack/")

def unzip4(filename):
    zf = zipfile.ZipFile(filename)
    filelist = zf.namelist()
    for filename in filelist:
        with zf.open(filename) as srcf:
            shutil.copyfileobj(srcf, dstfile)

