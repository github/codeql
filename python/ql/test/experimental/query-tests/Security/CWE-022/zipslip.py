#!/usr/bin/python
import sys, os, zipfile

unsafe_filename_zip = sys.argv[1]
safe_filename_zip = "safe_path.zip"

# GOOD, extract from infolist using safe name
with zipfile.ZipFile(safe_filename_zip) as zip:
    for entry in zip.infolist():
        zip.extract(entry)

# GOOD, extract from namelist using safe name
with zipfile.ZipFile(safe_filename_zip) as zip:
    for entry in zip.namelist():
        zip.extract(entry)

# BAD, extract from infolist using unsafe name
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.infolist():
        zip.extract(entry)

# BAD, extract from namelist using unsafe name
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.namelist():
        zip.extract(entry)

# BAD, extractall using unsafe name
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    zip.extractall()

# GOOD, extractall using safe name
with zipfile.ZipFile(safe_filename_zip) as zip:
    zip.extractall()

#Sanitized
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.infolist():
        if os.path.isabs(entry) or ".." in entry:
            raise ValueError("Illegal zip archive entry")
        zip.extract(entry, "/tmp/unpack/")

#Part Sanitized
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.infolist():
        if ".." in entry:
            raise ValueError("Illegal zip archive entry")
        zip.extract(entry, "/tmp/unpack/")

#Unsanitized members
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    zip.extractall(members=zip.infolist())

# Wrong sanitizer (is missing not)
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.infolist():
        if os.path.isabs(entry) or ".." in entry:
            zip.extract(entry, "/tmp/unpack/")


# OK Sanitized using not
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.infolist():
        if not (os.path.isabs(entry) or ".." in entry):
            zip.extract(entry, "/tmp/unpack/")

# The following two variants are included by purpose, since by default there is a
# difference in handling `not x` and `not (x or False)` when overriding
# Sanitizer.sanitizingEdge. We want to ensure we handle both consistently.

# Not reported, although vulnerable to '..'
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.infolist():
        if not (os.path.isabs(entry) or False):
            zip.extract(entry, "/tmp/unpack/")

# Not reported, although vulnerable to '..'
with zipfile.ZipFile(unsafe_filename_zip) as zip:
    for entry in zip.infolist():
        if not os.path.isabs(entry):
            zip.extract(entry, "/tmp/unpack/")
