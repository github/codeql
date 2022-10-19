# https://github.com/PyCQA/bandit

import sys
import tarfile
import tempfile

def managed_members_archive_handler(filename):
    tar = tarfile.open(filename)
    tar.extractall(path=tempfile.mkdtemp(), members=members_filter(tar))
    tar.close()


def members_filter(tarfile):
    result = []
    for member in tarfile:
        if member.issym() or member.islnk():
            print('Symlink to external resource')
            continue    
        result.append(member)
    return result


if __name__ == "__main__":
    if len(sys.argv) > 1:
        filename = sys.argv[1]
        managed_members_archive_handler(filename)
