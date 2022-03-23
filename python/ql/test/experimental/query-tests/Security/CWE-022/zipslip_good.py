import zipfile 
import tarfile
import shutil

def unzip(filename, dir):
    zf = zipfile.ZipFile(filename)
    zf.extractall(dir)
    

def unzip1(filename, dir):
    zf = zipfile.ZipFile(filename)
    zf.extract(dir)
  

