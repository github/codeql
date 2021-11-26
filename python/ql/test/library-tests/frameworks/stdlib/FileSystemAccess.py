import builtins
import io
import os

open("filepath")  # $ getAPathArgument="filepath"
open(file="filepath")  # $ getAPathArgument="filepath"

o = open

o("filepath")  # $ getAPathArgument="filepath"
o(file="filepath")  # $ getAPathArgument="filepath"


builtins.open("filepath")  # $ getAPathArgument="filepath"
builtins.open(file="filepath")  # $ getAPathArgument="filepath"


io.open("filepath")  # $ getAPathArgument="filepath"
io.open(file="filepath")  # $ getAPathArgument="filepath"

f = open("path") # $ getAPathArgument="path"
f.write("foo") # $ getAPathArgument="path" fileWriteData="foo"
lines = ["foo"]
f.writelines(lines) # $ getAPathArgument="path" fileWriteData=lines


def through_function(open_file):
    open_file.write("foo") # $ fileWriteData="foo" getAPathArgument="path"

through_function(f)

# os.path
os.path.exists("filepath")  # $ getAPathArgument="filepath"
os.path.isfile("filepath")  # $ getAPathArgument="filepath"
os.path.isdir("filepath")  # $ getAPathArgument="filepath"
os.path.islink("filepath")  # $ getAPathArgument="filepath"
os.path.ismount("filepath")  # $ getAPathArgument="filepath"

# actual os.path implementations
import posixpath
import ntpath
import genericpath

posixpath.exists("filepath") # $ getAPathArgument="filepath"
ntpath.exists("filepath") # $ getAPathArgument="filepath"
genericpath.exists("filepath") # $ getAPathArgument="filepath"

# os
os.stat("filepath") # $ getAPathArgument="filepath"
os.stat(path="filepath") # $ getAPathArgument="filepath"
