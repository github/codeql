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


#Sanitized
tar = tarfile.open(unsafe_filename_tar)
for entry in tar:
    if os.path.isabs(entry.name) or ".." in entry.name:
        raise ValueError("Illegal tar archive entry")
    tar.extract(entry, "/tmp/unpack/")

#Part Sanitized
tar = tarfile.open(unsafe_filename_tar)
for entry in tar:
    if ".." in entry.name:
        raise ValueError("Illegal tar archive entry")
    tar.extract(entry, "/tmp/unpack/")

#Unsanitized members
tar = tarfile.open(unsafe_filename_tar)
tar.extractall(members=tar)


#Sanitize members
def safemembers(members):
    for info in members:
        if badpath(info):
            raise
        yield info

tar = tarfile.open(unsafe_filename_tar)
tar.extractall(members=safemembers(tar))
