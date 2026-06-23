#!/usr/bin/python

import sys
import tarfile
import tempfile
import os
from tarfile import TarFile
from contextlib import closing, contextmanager
import subprocess
import os.path

unsafe_filename_tar = sys.argv[2]
safe_filename_tar = "safe_path.tar"

tar = tarfile.open(unsafe_filename_tar) # $ Source[py/tarslip-extended]
result = []
for member in tar:
    if ".." in member.name:
        raise ValueError("Path in member name !!!")    
    result.append(member)
path = unsafe_filename_tar
tar.extractall(path=path, members=result) # $ Alert[py/tarslip-extended]
tar.close()


def members_filter1(tarfile):
    result = []
    for member in tarfile:
        if '../' in member.name:
            print('Member name container directory traversal sequence')
            continue
        elif member.issym() or member.islnk():
            print('Symlink to external resource')
            continue    
        result.append(member)
    return result

tar = tarfile.open(unsafe_filename_tar) # $ Source[py/tarslip-extended]
tar.extractall(path=tempfile.mkdtemp(), members=members_filter1(tar)) # $ Alert[py/tarslip-extended]
tar.close()


with tarfile.open(unsafe_filename_tar) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        if ".." in entry.name:
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/") # $ Alert[py/tarslip-extended]


def _validate_archive_name(name, target):
    if not os.path.abspath(os.path.join(target, name)).startswith(target + os.path.sep):
        raise ValueError(f"Provided language pack contains invalid name {name}")

with tarfile.open(unsafe_filename_tar) as tar: # $ Source[py/tarslip-extended]
    target = "/tmp/unpack"
    for entry in tar:
        _validate_archive_name(entry.name, target)
        tar.extract(entry, target) # $ Alert[py/tarslip-extended]


def members_filter2(tarfile):
    result = []
    for member in tarfile.getmembers():
        if '../' in member.name:
            print('Member name container directory traversal sequence')
            continue
        elif (member.issym() or member.islnk()) and ('../' in member.linkname):
            print('Symlink to external resource')
            continue    
        result.append(member)
    return result

tar = tarfile.open(unsafe_filename_tar)
tar.extractall(path=tempfile.mkdtemp(), members=members_filter2(tar))
tar.close()


def _validate_tar_info(info, target):
    _validate_archive_name(info.name, target)
    if not (info.isfile() or info.isdir()):
        raise ValueError("Provided language pack contains invalid file type")

def _validate_archive_name(name, target):
    if not os.path.abspath(os.path.join(target, name)).startswith(target + os.path.sep):
        raise ValueError(f"Provided language pack contains invalid name {name}")

target = "/tmp/unpack"
with tarfile.open(unsafe_filename_tar, "r") as tar: # $ Source[py/tarslip-extended]
    for info in tar.getmembers():
        _validate_tar_info(info, target)
    tar.extractall(target) # $ Alert[py/tarslip-extended]


def members_filter3(tarfile):
    result = []
    for member in tarfile.getmembers():
        if '../' in member.name:
            print('Member name container directory traversal sequence')
            continue
        elif member.issym() or member.islnk():
            print('Symlink to external resource')
            continue    
        result.append(member)
    return result

tar = tarfile.open(unsafe_filename_tar)
tar.extractall(path=tempfile.mkdtemp(), members=members_filter3(tar))
tar.close()

    
tar = tarfile.open(unsafe_filename_tar) # $ Source[py/tarslip-extended]
tarf = tar.getmembers()
for f in tarf:
    if not f.issym():
        tar.extractall(path=tempfile.mkdtemp(), members=[f]) # $ Alert[py/tarslip-extended]
tar.close()


class MKTar(TarFile):
    pass

tarball = unsafe_filename_tar
with MKTar.open(name=tarball) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        tar._extract_member(entry, entry.name) # $ Alert[py/tarslip-extended]


tarball = unsafe_filename_tar
with tarfile.open(tarball) as tar: # $ Source[py/tarslip-extended]
    tar.extractall() # $ Alert[py/tarslip-extended]


tar = tarfile.open(unsafe_filename_tar) # $ Source[py/tarslip-extended]
tar.extractall(path=tempfile.mkdtemp(), members=None) # $ Alert[py/tarslip-extended]


class MKTar(tarfile.TarFile):
    pass

tarball = unsafe_filename_tar
with MKTar.open(name=tarball) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        tar._extract_member(entry, entry.name) # $ Alert[py/tarslip-extended]


@contextmanager
def py2_tarxz(filename):
    with tempfile.TemporaryFile() as tmp:
        subprocess.check_call(["xz", "-dc", filename], stdout=tmp.fileno())
        tmp.seek(0)
        with closing(tarfile.TarFile(fileobj=tmp)) as tf: # $ Source[py/tarslip-extended]
            yield tf

def unpack_tarball(tar_filename, dest):     
    if sys.version_info[0] < 3 and tar_filename.endswith('.xz'):
        # Py 2.7 lacks lzma support
        tar_cm = py2_tarxz(tar_filename)
    else:
        tar_cm = closing(tarfile.open(tar_filename)) # $ Source[py/tarslip-extended]

    base_dir = None
    with tar_cm as tarc:
        for member in tarc:
            base_name = member.name.split('/')[0]
            if base_dir is None:
                base_dir = base_name
            elif base_dir != base_name:
                print('Unexpected path in %s: %s' % (tar_filename, base_name))
        tarc.extractall(dest) # $ Alert[py/tarslip-extended]
    return os.path.join(dest, base_dir)

unpack_tarball(unsafe_filename_tar, "/tmp/unpack")


tarball = unsafe_filename_tar
with tarfile.open(name=tarball) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        tar._extract_member(entry, entry.name) # $ Alert[py/tarslip-extended]


tarball = unsafe_filename_tar
with tarfile.open(name=tarball) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        tar.extract(entry, "/tmp/unpack/") # $ Alert[py/tarslip-extended]


tarball = unsafe_filename_tar
tar = tarfile.open(tarball) # $ Source[py/tarslip-extended]
tar.extractall("/tmp/unpack/") # $ Alert[py/tarslip-extended]


tarball = unsafe_filename_tar
with tarfile.open(tarball, "r") as tar: # $ Source[py/tarslip-extended]
    tar.extractall(path="/tmp/unpack/", members=tar) # $ Alert[py/tarslip-extended]


def members_filter4(tarfile):
    result = []
    for member in tarfile.getmembers():
        if member.issym() or member.islnk():
            print('Symlink to external resource')
            continue    
        result.append(member)
    return result
tar = tarfile.open(unsafe_filename_tar)
tar.extractall(path=tempfile.mkdtemp(), members=members_filter4(tar))
tar.close()


with tarfile.open(unsafe_filename_tar, "r") as tar: # $ Source[py/tarslip-extended]
    tar.extractall(path="/tmp/unpack") # $ Alert[py/tarslip-extended]


def members_filter5(tarfile):
    result = []
    for member in tarfile.getmembers():
        if member.issym():
            print('Symlink to external resource')
            continue    
        result.append(member)
    return result
tar = tarfile.open(unsafe_filename_tar)
tar.extractall(path=tempfile.mkdtemp(), members=members_filter5(tar))
tar.close()


filename = unsafe_filename_tar
tmp_dir = "/tmp/"

read_type = "r:gz" if filename.endswith("tgz") else "r"
with tarfile.open(filename, read_type) as corpus_tar: # $ Source[py/tarslip-extended]
    members = []
    for f in corpus_tar:
        if not os.path.isfile(os.path.join(tmp_dir, f.name)):
            members.append(f)
    corpus_tar.extractall(tmp_dir, members=members) # $ Alert[py/tarslip-extended]


def members_filter6(tarfile):
    result = []
    for member in tarfile.getmembers():
        if not member.isreg():
            print('Symlink to external resource')
            continue    
        result.append(member)
    return result
tar = tarfile.open(filename)
tar.extractall(path=tempfile.mkdtemp(), members=members_filter6(tar))
tar.close()


archive_path = unsafe_filename_tar
target_dir = "/tmp/unpack"
tarfile.open(archive_path, "r").extractall(path=target_dir) # $ Alert[py/tarslip-extended]


tarball = unsafe_filename_tar
with tarfile.open(tarball) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        if entry.isfile():
            tar.extract(entry, "/tmp/unpack/") # $ Alert[py/tarslip-extended]


with tarfile.open(unsafe_filename_tar) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        if entry.name.startswith("/"):
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/") # $ Alert[py/tarslip-extended]

tarball = unsafe_filename_tar
with tarfile.TarFile(tarball, mode="r") as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        if entry.isfile():
            tar.extract(entry, "/tmp/unpack/") # $ Alert[py/tarslip-extended]

with tarfile.open(unsafe_filename_tar) as tar: # $ Source[py/tarslip-extended]
    for entry in tar:
        if os.path.isabs(entry.name):
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/") # $ Alert[py/tarslip-extended]


with tarfile.TarFile(unsafe_filename_tar, mode="r") as tar: # $ Source[py/tarslip-extended]
    tar.extractall(path="/tmp/unpack") # $ Alert[py/tarslip-extended]


tar = tarfile.open(filename) # $ Source[py/tarslip-extended]
tar.extractall(path=tempfile.mkdtemp(), members=tar.getmembers()) # $ Alert[py/tarslip-extended]
tar.close()


tar = tarfile.open(unsafe_filename_tar) # $ Source[py/tarslip-extended]
tar.extractall(path=tempfile.mkdtemp(), members=None) # $ Alert[py/tarslip-extended]


tar.extractall(path=tempfile.mkdtemp(), members=members_filter4(tar))
tar.close()


with tarfile.TarFile(unsafe_filename_tar, mode="r") as tar: # $ Source[py/tarslip-extended]
    tar.extractall(path="/tmp/unpack/", members=tar) # $ Alert[py/tarslip-extended]


tar = tarfile.open(unsafe_filename_tar) # $ Source[py/tarslip-extended]
result = []
for member in tar:
    if member.issym():
        raise ValueError("But it is a symlink")   
    result.append(member)
tar.extractall(path=tempfile.mkdtemp(), members=result) # $ Alert[py/tarslip-extended]
tar.close()


archive_path = unsafe_filename_tar
target_dir = "/tmp/unpack"
tarfile.TarFile(unsafe_filename_tar, mode="r").extractall(path=target_dir) # $ Alert[py/tarslip-extended]