import builtins
import io
import os
import stat
import tempfile
import shutil

open("file")  # $ getAPathArgument="file"
open(file="file")  # $ getAPathArgument="file"

o = open

o("file")  # $ getAPathArgument="file"
o(file="file")  # $ getAPathArgument="file"


builtins.open("file")  # $ getAPathArgument="file"
builtins.open(file="file")  # $ getAPathArgument="file"


io.open("file")  # $ getAPathArgument="file"
io.open(file="file")  # $ getAPathArgument="file"

f = open("path") # $ getAPathArgument="path"
f.write("foo") # $ getAPathArgument="path" fileWriteData="foo"
lines = ["foo"]
f.writelines(lines) # $ getAPathArgument="path" fileWriteData=lines


def through_function(open_file):
    open_file.write("foo") # $ fileWriteData="foo" getAPathArgument="path"

through_function(f)

# os.path
os.path.exists("path")  # $ getAPathArgument="path"
os.path.exists(path="path")  # $ getAPathArgument="path"

os.path.isfile("path")  # $ getAPathArgument="path"
os.path.isfile(path="path")  # $ getAPathArgument="path"

os.path.isdir("s")  # $ getAPathArgument="s"
os.path.isdir(s="s")  # $ getAPathArgument="s"

os.path.islink("path")  # $ getAPathArgument="path"
os.path.islink(path="path")  # $ getAPathArgument="path"

os.path.ismount("path")  # $ getAPathArgument="path"
os.path.ismount(path="path")  # $ getAPathArgument="path"

os.path.samefile("f1", "f2")  # $ getAPathArgument="f1" getAPathArgument="f2"
os.path.samefile(f1="f1", f2="f2")  # $ getAPathArgument="f1" getAPathArgument="f2"

# actual os.path implementations
import posixpath
import ntpath
import genericpath

posixpath.exists("path") # $ getAPathArgument="path"
posixpath.exists(path="path") # $ getAPathArgument="path"

ntpath.exists("path") # $ getAPathArgument="path"
ntpath.exists(path="path") # $ getAPathArgument="path"

genericpath.exists("path") # $ getAPathArgument="path"
genericpath.exists(path="path") # $ getAPathArgument="path"

# os

def test_fsencode_fsdecode():
    # notice that this does not make a file system access, but performs encoding/decoding.
    os.fsencode("filename") # $ encodeInput="filename" encodeOutput=os.fsencode(..) encodeFormat=filesystem
    os.fsencode(filename="filename") # $ encodeInput="filename" encodeOutput=os.fsencode(..) encodeFormat=filesystem

    os.fsdecode("filename") # $ decodeInput="filename" decodeOutput=os.fsdecode(..) decodeFormat=filesystem
    os.fsdecode(filename="filename") # $ decodeInput="filename" decodeOutput=os.fsdecode(..) decodeFormat=filesystem

def test_fspath():
    # notice that this does not make a file system access, but returns the path
    # representation of a path-like object.

    ensure_tainted(
        TAINTED_STRING, # $ tainted
        os.fspath(TAINTED_STRING), # $ tainted
        os.fspath(path=TAINTED_STRING), # $ tainted
    )

os.open("path", os.O_RDONLY) # $ getAPathArgument="path"
os.open(path="path", flags=os.O_RDONLY) # $ getAPathArgument="path"

os.access("path", os.R_OK) # $ getAPathArgument="path"
os.access(path="path", mode=os.R_OK) # $ getAPathArgument="path"

os.chdir("path") # $ getAPathArgument="path"
os.chdir(path="path") # $ getAPathArgument="path"

os.chflags("path", stat.UF_NODUMP) # $ getAPathArgument="path"
os.chflags(path="path", flags=stat.UF_NODUMP) # $ getAPathArgument="path"

os.chmod("path", 0o700) # $ getAPathArgument="path"
os.chmod(path="path", mode=0o700) # $ getAPathArgument="path"

os.chown("path", -1, -1) # $ getAPathArgument="path"
os.chown(path="path", uid=-1, gid=-1) # $ getAPathArgument="path"

# unix only
os.chroot("path") # $ getAPathArgument="path"
os.chroot(path="path") # $ getAPathArgument="path"

# unix only
os.lchflags("path", stat.UF_NODUMP) # $ getAPathArgument="path"
os.lchflags(path="path", flags=stat.UF_NODUMP) # $ getAPathArgument="path"

# unix only
os.lchmod("path", 0o700) # $ getAPathArgument="path"
os.lchmod(path="path", mode=0o700) # $ getAPathArgument="path"

# unix only
os.lchown("path", -1, -1) # $ getAPathArgument="path"
os.lchown(path="path", uid=-1, gid=-1) # $ getAPathArgument="path"

os.link("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
os.link(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

os.listdir("path") # $ getAPathArgument="path"
os.listdir(path="path") # $ getAPathArgument="path"

os.lstat("path") # $ getAPathArgument="path"
os.lstat(path="path") # $ getAPathArgument="path"

os.mkdir("path") # $ getAPathArgument="path"
os.mkdir(path="path") # $ getAPathArgument="path"

os.makedirs("name") # $ getAPathArgument="name"
os.makedirs(name="name") # $ getAPathArgument="name"

os.mkfifo("path") # $ getAPathArgument="path"
os.mkfifo(path="path") # $ getAPathArgument="path"

os.mknod("path") # $ getAPathArgument="path"
os.mknod(path="path") # $ getAPathArgument="path"

os.pathconf("path", "name") # $ getAPathArgument="path"
os.pathconf(path="path", name="name") # $ getAPathArgument="path"

os.readlink("path") # $ getAPathArgument="path"
os.readlink(path="path") # $ getAPathArgument="path"

os.remove("path") # $ getAPathArgument="path"
os.remove(path="path") # $ getAPathArgument="path"

os.removedirs("name") # $ getAPathArgument="name"
os.removedirs(name="name") # $ getAPathArgument="name"

os.rename("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
os.rename(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

os.renames("old", "new") # $ getAPathArgument="old" getAPathArgument="new"
os.renames(old="old", new="new") # $ getAPathArgument="old" getAPathArgument="new"

os.replace("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
os.replace(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

os.rmdir("path") # $ getAPathArgument="path"
os.rmdir(path="path") # $ getAPathArgument="path"

os.scandir("path") # $ getAPathArgument="path"
os.scandir(path="path") # $ getAPathArgument="path"

os.stat("path") # $ getAPathArgument="path"
os.stat(path="path") # $ getAPathArgument="path"

os.statvfs("path") # $ getAPathArgument="path"
os.statvfs(path="path") # $ getAPathArgument="path"

os.symlink("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
os.symlink(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

os.truncate("path", 42) # $ getAPathArgument="path"
os.truncate(path="path", length=42) # $ getAPathArgument="path"

os.unlink("path") # $ getAPathArgument="path"
os.unlink(path="path") # $ getAPathArgument="path"

os.utime("path") # $ getAPathArgument="path"
os.utime(path="path") # $ getAPathArgument="path"

os.walk("top") # $ getAPathArgument="top"
os.walk(top="top") # $ getAPathArgument="top"

os.fwalk("top") # $ getAPathArgument="top"
os.fwalk(top="top") # $ getAPathArgument="top"

# Linux only
os.getxattr("path", "attribute") # $ getAPathArgument="path"
os.getxattr(path="path", attribute="attribute") # $ getAPathArgument="path"

# Linux only
os.listxattr("path") # $ getAPathArgument="path"
os.listxattr(path="path") # $ getAPathArgument="path"

# Linux only
os.removexattr("path", "attribute") # $ getAPathArgument="path"
os.removexattr(path="path", attribute="attribute") # $ getAPathArgument="path"

# Linux only
os.setxattr("path", "attribute", "value") # $ getAPathArgument="path"
os.setxattr(path="path", attribute="attribute", value="value") # $ getAPathArgument="path"

# Windows only
os.add_dll_directory("path") # $ getAPathArgument="path"
os.add_dll_directory(path="path") # $ getAPathArgument="path"

# for `os.exec*`, `os.spawn*`, and `os.posix_spawn*` functions, see the
# `SystemCommandExecution.py` file.

# Windows only
os.startfile("path") # $ getAPathArgument="path"
os.startfile(path="path") # $ getAPathArgument="path"

# ------------------------------------------------------------------------------
# tempfile
# ------------------------------------------------------------------------------

# _mkstemp_inner does `_os.path.join(dir, pre + name + suf)`

tempfile.mkstemp("suffix", "prefix", "dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"
tempfile.mkstemp(suffix="suffix", prefix="prefix", dir="dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"

tempfile.NamedTemporaryFile('w+b', -1, None, None, "suffix", "prefix", "dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"
tempfile.NamedTemporaryFile(suffix="suffix", prefix="prefix", dir="dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"

tempfile.TemporaryFile('w+b', -1, None, None, "suffix", "prefix", "dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"
tempfile.TemporaryFile(suffix="suffix", prefix="prefix", dir="dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"

tempfile.SpooledTemporaryFile(0, 'w+b', -1, None, None, "suffix", "prefix", "dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"
tempfile.SpooledTemporaryFile(suffix="suffix", prefix="prefix", dir="dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"

# mkdtemp does `_os.path.join(dir, prefix + name + suffix)`
tempfile.mkdtemp("suffix", "prefix", "dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"
tempfile.mkdtemp(suffix="suffix", prefix="prefix", dir="dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"

tempfile.TemporaryDirectory("suffix", "prefix", "dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"
tempfile.TemporaryDirectory(suffix="suffix", prefix="prefix", dir="dir") # $ getAPathArgument="suffix" getAPathArgument="prefix" getAPathArgument="dir"

# ------------------------------------------------------------------------------
# shutil
# ------------------------------------------------------------------------------

shutil.rmtree("path") # $ getAPathArgument="path"
shutil.rmtree(path="path") # $ getAPathArgument="path"

shutil.copyfile("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
shutil.copyfile(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

shutil.copy("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
shutil.copy(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

shutil.copy2("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
shutil.copy2(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

shutil.copytree("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
shutil.copytree(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

shutil.move("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
shutil.move(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

shutil.copymode("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
shutil.copymode(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

shutil.copystat("src", "dst") # $ getAPathArgument="src" getAPathArgument="dst"
shutil.copystat(src="src", dst="dst") # $ getAPathArgument="src" getAPathArgument="dst"

shutil.disk_usage("path") # $ getAPathArgument="path"
shutil.disk_usage(path="path") # $ getAPathArgument="path"
