import tarfile
import sys

with tarfile.open(sys.argv[1], "r") as tar:
    tar.extractall(path="/tmp/unpack")
