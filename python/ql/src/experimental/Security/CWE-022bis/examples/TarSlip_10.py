import tarfile
import sys

tarball = sys.argv[1]
with tarfile.open(tarball, "r") as tar:
    tar.extractall(path="/tmp/unpack/", members=tar)
