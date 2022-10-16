from fileinput import filename
import tarfile
import os.path
import sys

archive_path = sys.argv[1]
target_dir = "/tmp/unpack"
tarfile.open(archive_path, "r").extractall(path=target_dir)
