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

tar = tarfile.open(unsafe_filename_tar)
result = []
for member in tar:
    if ".." in member.name:
        raise ValueError("Path in member name !!!")    
    result.append(member)
path = unsafe_filename_tar
tar.extractall(path=path, members=result)
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

tar = tarfile.open(unsafe_filename_tar)
tar.extractall(path=tempfile.mkdtemp(), members=members_filter1(tar))
tar.close()


with tarfile.open(unsafe_filename_tar) as tar:
    for entry in tar:
        if ".." in entry.name:
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/")


def _validate_archive_name(name, target):
    if not os.path.abspath(os.path.join(target, name)).startswith(target + os.path.sep):
        raise ValueError(f"Provided language pack contains invalid name {name}")

with tarfile.open(unsafe_filename_tar) as tar:
    target = "/tmp/unpack"
    for entry in tar:
        _validate_archive_name(entry.name, target)
        tar.extract(entry, target)


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
with tarfile.open(unsafe_filename_tar, "r") as tar:
    for info in tar.getmembers():
        _validate_tar_info(info, target)
    tar.extractall(target)


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

    
tar = tarfile.open(unsafe_filename_tar)
tarf = tar.getmembers()
for f in tarf:
    if not f.issym():
        tar.extractall(path=tempfile.mkdtemp(), members=[f])
tar.close()


class MKTar(TarFile):
    pass

tarball = unsafe_filename_tar
with MKTar.open(name=tarball) as tar:
    for entry in tar:
        tar._extract_member(entry, entry.name)


tarball = unsafe_filename_tar
with tarfile.open(tarball) as tar:
    tar.extractall()


tar = tarfile.open(unsafe_filename_tar)
tar.extractall(path=tempfile.mkdtemp(), members=None)


class MKTar(tarfile.TarFile):
    pass

tarball = unsafe_filename_tar
with MKTar.open(name=tarball) as tar:
    for entry in tar:
        tar._extract_member(entry, entry.name)


@contextmanager
def py2_tarxz(filename):
    with tempfile.TemporaryFile() as tmp:
        subprocess.check_call(["xz", "-dc", filename], stdout=tmp.fileno())
        tmp.seek(0)
        with closing(tarfile.TarFile(fileobj=tmp)) as tf:
            yield tf

def unpack_tarball(tar_filename, dest):     
    if sys.version_info[0] < 3 and tar_filename.endswith('.xz'):
        # Py 2.7 lacks lzma support
        tar_cm = py2_tarxz(tar_filename)
    else:
        tar_cm = closing(tarfile.open(tar_filename))

    base_dir = None
    with tar_cm as tarc:
        for member in tarc:
            base_name = member.name.split('/')[0]
            if base_dir is None:
                base_dir = base_name
            elif base_dir != base_name:
                print('Unexpected path in %s: %s' % (tar_filename, base_name))
        tarc.extractall(dest)
    return os.path.join(dest, base_dir)

unpack_tarball(unsafe_filename_tar, "/tmp/unpack")


tarball = unsafe_filename_tar
with tarfile.open(name=tarball) as tar:
    for entry in tar:
        tar._extract_member(entry, entry.name)


tarball = unsafe_filename_tar
with tarfile.open(name=tarball) as tar:
    for entry in tar:
        tar.extract(entry, "/tmp/unpack/")


tarball = unsafe_filename_tar
tar = tarfile.open(tarball)
tar.extractall("/tmp/unpack/")


tarball = unsafe_filename_tar
with tarfile.open(tarball, "r") as tar:
    tar.extractall(path="/tmp/unpack/", members=tar)


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


with tarfile.open(unsafe_filename_tar, "r") as tar:
    tar.extractall(path="/tmp/unpack")


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
with tarfile.open(filename, read_type) as corpus_tar:
    members = []
    for f in corpus_tar:
        if not os.path.isfile(os.path.join(tmp_dir, f.name)):
            members.append(f)
    corpus_tar.extractall(tmp_dir, members=members)


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
tarfile.open(archive_path, "r").extractall(path=target_dir)


tarball = unsafe_filename_tar
with tarfile.open(tarball) as tar:
    for entry in tar:
        if entry.isfile():
            tar.extract(entry, "/tmp/unpack/")


with tarfile.open(unsafe_filename_tar) as tar:
    for entry in tar:
        if entry.name.startswith("/"):
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/")

tarball = unsafe_filename_tar
with tarfile.TarFile(tarball, mode="r") as tar:
    for entry in tar:
        if entry.isfile():
            tar.extract(entry, "/tmp/unpack/")

with tarfile.open(unsafe_filename_tar) as tar:
    for entry in tar:
        if os.path.isabs(entry.name):
            raise ValueError("Illegal tar archive entry")
        tar.extract(entry, "/tmp/unpack/")


with tarfile.TarFile(unsafe_filename_tar, mode="r") as tar:
    tar.extractall(path="/tmp/unpack")


tar = tarfile.open(filename)
tar.extractall(path=tempfile.mkdtemp(), members=tar.getmembers())
tar.close()


tar = tarfile.open(unsafe_filename_tar)
tar.extractall(path=tempfile.mkdtemp(), members=None)


tar.extractall(path=tempfile.mkdtemp(), members=members_filter4(tar))
tar.close()


with tarfile.TarFile(unsafe_filename_tar, mode="r") as tar:
    tar.extractall(path="/tmp/unpack/", members=tar)


tar = tarfile.open(unsafe_filename_tar)
result = []
for member in tar:
    if member.issym():
        raise ValueError("But it is a symlink")   
    result.append(member)
tar.extractall(path=tempfile.mkdtemp(), members=result)
tar.close()


archive_path = unsafe_filename_tar
target_dir = "/tmp/unpack"
tarfile.TarFile(unsafe_filename_tar, mode="r").extractall(path=target_dir)