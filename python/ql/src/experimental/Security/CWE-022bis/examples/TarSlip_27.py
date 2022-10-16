from fileinput import filename
import tarfile
import os.path
import sys

archive_path = sys.argv[1]
target_dir = "/tmp/unpack"
tarfile.TarFile(sys.argv[1], mode="r").extractall(path=target_dir)