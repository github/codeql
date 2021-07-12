import builtins
import io

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
