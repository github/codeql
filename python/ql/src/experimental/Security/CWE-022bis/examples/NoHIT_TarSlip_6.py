# https://github.com/OctoPrint/OctoPrint/

import sys
import tarfile
import os

def _validate_tar_info(info, target):
    _validate_archive_name(info.name, target)
    if not (info.isfile() or info.isdir()):
        raise ValueError("Provided language pack contains invalid file type")

def _validate_archive_name(name, target):
    if not os.path.abspath(os.path.join(target, name)).startswith(target + os.path.sep):
        raise ValueError(f"Provided language pack contains invalid name {name}")

target = "/tmp/unpack"

with tarfile.open(sys.argv[1], "r") as tar:

    # sanity check
    for info in tar.getmembers():
        _validate_tar_info(info, target)

    # unpack everything
    tar.extractall(target)

