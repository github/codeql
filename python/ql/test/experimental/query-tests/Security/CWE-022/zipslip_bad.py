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
    with zipfile.ZipFile(filename) as zipf:
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.copy(entry, "/tmp/unpack/")

def unzip4(filename):
    with zipfile.ZipFile(filename) as zipf:
        for entry in zipf:
            with open(entry, 'wb') as dstfile:
                shutil.copyfileobj(zipf, dstfile)
          

