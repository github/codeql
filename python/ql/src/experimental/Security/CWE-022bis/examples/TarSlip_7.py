import tarfile
import sys

tarball = sys.argv[1]
with tarfile.open(name=tarball) as tar:
    for entry in tar:
        tar._extract_member(entry, entry.name)
