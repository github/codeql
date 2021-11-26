import builtins
import io
import os

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
os.stat("path") # $ getAPathArgument="path"
os.stat(path="path") # $ getAPathArgument="path"
