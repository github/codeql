import tarfile
import sys
import os

def _validate_archive_name(name, target):
    if not os.path.abspath(os.path.join(target, name)).startswith(target + os.path.sep):
        raise ValueError(f"Provided language pack contains invalid name {name}")

with tarfile.open(sys.argv[1]) as tar:
    target = "/tmp/unpack"
    for entry in tar:
        _validate_archive_name(entry.name, target)
        tar.extract(entry, target)
