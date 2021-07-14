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


# Wrong sanitizer (is missing not)
tar = tarfile.open(unsafe_filename_tar)
for entry in tar:
    if os.path.isabs(entry.name) or ".." in entry.name:
        tar.extract(entry, "/tmp/unpack/")


# OK Sanitized using not
tar = tarfile.open(unsafe_filename_tar)
for entry in tar:
    if not (os.path.isabs(entry.name) or ".." in entry.name):
        tar.extract(entry, "/tmp/unpack/")

# The following two variants are included by purpose, since by default there is a
# difference in handling `not x` and `not (x or False)` when overriding
# Sanitizer.sanitizingEdge. We want to ensure we handle both consistently.

# Not reported, although vulnerable to '..'
tar = tarfile.open(unsafe_filename_tar)
for entry in tar:
    if not (os.path.isabs(entry.name) or False):
        tar.extract(entry, "/tmp/unpack/")

# Not reported, although vulnerable to '..'
tar = tarfile.open(unsafe_filename_tar)
for entry in tar:
    if not os.path.isabs(entry.name):
        tar.extract(entry, "/tmp/unpack/")
