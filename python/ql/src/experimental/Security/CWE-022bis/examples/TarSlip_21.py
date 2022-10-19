import tarfile
import sys

with tarfile.TarFile(sys.argv[1], mode="r") as tar:
    tar.extractall(path="/tmp/unpack")