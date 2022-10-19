import tarfile
import sys
import os

with tarfile.open(sys.argv[1]) as tar:
    for entry in tar:
        if os.path.isabs(entry.name):
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/")
