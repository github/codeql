import zipfile
import shutil


zf = zipfile.ZipFile(filename)
with zf.open() as zipf:
    #BAD : This could write any file on the filesystem.
    for entry in zipf:
       shutil.copy(entry, "/tmp/unpack/")
