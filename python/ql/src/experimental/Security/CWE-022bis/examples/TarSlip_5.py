import tarfile
import sys

class MKTar(tarfile.TarFile):
    pass

tarball = sys.argv[1]
with MKTar.open(name=tarball) as tar:
    for entry in tar:
        tar._extract_member(entry, entry.name)
