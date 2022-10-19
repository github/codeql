import tarfile
import sys

tarball = sys.argv[1]
tar = tarfile.open(tarball)
tar.extractall("/tmp/unpack/")
