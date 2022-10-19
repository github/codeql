import tarfile
import sys

tarball = sys.argv[1]
with tarfile.TarFile(tarball, mode="r") as tar:
    for entry in tar:
        if entry.isfile():
            tar.extract(entry, "/tmp/unpack/")
