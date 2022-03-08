import zipfile 
import tarfile
import shutil

def unzip(filename, dir):
  zf = zipfile.ZipFile(filename)
  zf.extractall(dir)
    

def unzip1(filename, dir):
  zf = zipfile.ZipFile(filename)
  zf.extract(dir)
  
def unzip2(filename):
  with tarfile.open(filename) as tar:
    for entry in tar:
        #GOOD: Check that entry is safe
        if os.path.isabs(entry.name) or ".." in entry.name:
            raise ValueError("Illegal tar archive entry")
        shutil.copy(entry, "/tmp/unpack/")
