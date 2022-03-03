import zipfile
import shutil

def unzip(filename):
  zf = zipfile.ZipFile()
    with zf.open(filename) as zipf:
    #BAD : This could write any file on the filesystem.
       for entry in zipf:
          shutil.copyfileobj(entry, "/tmp/unpack/")
