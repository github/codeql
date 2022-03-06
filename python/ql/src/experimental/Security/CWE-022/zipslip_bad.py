import zipfile
import shutil

def unzip(filename):

   with zipfile.ZipFile(filename) as zipf:
    #BAD : This could write any file on the filesystem.
      for entry in zipf:
          shutil.copy(entry, "/tmp/unpack/")
