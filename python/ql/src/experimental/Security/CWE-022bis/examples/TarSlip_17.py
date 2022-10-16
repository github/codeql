import tarfile
import sys

tarball = sys.argv[1]
with tarfile.open(tarball) as tar:
    for entry in tar:
        if entry.isfile():
            tar.extract(entry, "/tmp/unpack/")
