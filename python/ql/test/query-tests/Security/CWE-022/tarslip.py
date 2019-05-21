#!/usr/bin/python
import tarfile

unsafe_filename_tar = sys.argv[1]
safe_filename_tar = "safe_path.tar"


tar = tarfile.open(safe_filename_tar)
for entry in tar:
    tar.extract(entry)

tar = tarfile.open(unsafe_filename_tar)
tar.extractall()
tar.close()

tar = tarfile.open(unsafe_filename_tar)
for entry in tar:
    tar.extract(entry)

tar = tarfile.open(safe_filename_tar)
tar.extractall()
tar.close()
