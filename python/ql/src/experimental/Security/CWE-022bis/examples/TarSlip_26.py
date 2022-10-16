# https://github.com/PyCQA/bandit

import sys
import tarfile
import tempfile

def managed_members_archive_handler(filename):
    tar = tarfile.open(filename)
    result = []
    for member in tar:
        if member.issym():
            raise ValueError("But it is a symlink")   
        result.append(member)
    tar.extractall(path=tempfile.mkdtemp(), members=result)
    tar.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        filename = sys.argv[1]
        managed_members_archive_handler(filename)
