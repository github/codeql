import sys
import tarfile
import tempfile

def managed_members_archive_handler(filename):
    tar = tarfile.open(filename)
    tar.extractall(path=tempfile.mkdtemp(), members=tar.getmembers())
    tar.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        filename = sys.argv[1]
        managed_members_archive_handler(filename)
