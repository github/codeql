import builtins
import io

open("filepath")  # $getAPathArgument="filepath"
open(file="filepath")  # $getAPathArgument="filepath"

o = open

o("filepath")  # $getAPathArgument="filepath"
o(file="filepath")  # $getAPathArgument="filepath"


builtins.open("filepath")  # $getAPathArgument="filepath"
builtins.open(file="filepath")  # $getAPathArgument="filepath"


io.open("filepath")  # $ MISSING: getAPathArgument="filepath"
io.open(file="filepath")  # $ MISSING: getAPathArgument="filepath"
