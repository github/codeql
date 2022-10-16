import tarfile
import sys

with tarfile.open(sys.argv[1]) as tar:
    for entry in tar:
        if ".." in entry.name:
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/")
