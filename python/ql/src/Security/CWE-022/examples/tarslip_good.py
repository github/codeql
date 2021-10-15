
import tarfile
import os.path

with tarfile.open('archive.zip') as tar:
    for entry in tar:
        #GOOD: Check that entry is safe
        if os.path.isabs(entry.name) or ".." in entry.name:
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/")
