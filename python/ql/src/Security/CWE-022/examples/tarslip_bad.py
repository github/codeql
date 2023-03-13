import sys
import tarfile

with tarfile.open(sys.argv[1]) as tar:
    #BAD : This could write any file on the filesystem.
    for entry in tar:
        tar.extract(entry, "/tmp/unpack/")
