import tarfile
import sys

tarball = sys.argv[1]
with tarfile.open(tarball) as tar:
    tar.extractall()
