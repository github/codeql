import zipfile
import shutil

def unzip(filename):
    with zipfile.ZipFile(filename) as zipf:
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.copy(entry, "/tmp/unpack/")
          
def unzip1(filename):
    with zipfile.ZipFile(filename) as zipf:
        for entry in zipf:
            with open(entry, 'wb') as dstfile:
                shutil.copyfileobj(zipf, dstfile)
