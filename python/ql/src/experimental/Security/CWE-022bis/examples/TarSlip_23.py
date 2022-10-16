import tarfile
import sys
import tempfile

tar = tarfile.open(sys.argv[1])
tar.extractall(path=tempfile.mkdtemp(), members=None)
