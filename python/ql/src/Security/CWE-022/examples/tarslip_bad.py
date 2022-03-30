
import tarfile

with tarfile.open('archive.zip') as tar:
    #BAD : This could write any file on the filesystem.
    for entry in tar:
        tar.extract(entry, "/tmp/unpack/")
