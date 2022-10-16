import sys
import tarfile

def managed_members_archive_handler(filename):
    tar = tarfile.open(filename)
    result = []
    for member in tar:
        if ".." in member.name:
            raise ValueError("Path in member name !!!")    
        result.append(member)
    path = sys.argv[2]
    #print("files are extracted to: ", path)
    tar.extractall(path=path, members=result)
    tar.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        filename = sys.argv[1]
        managed_members_archive_handler(filename)
