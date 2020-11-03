open("filepath")  # $getAPathArgument="filepath"
open(file="filepath")  # $getAPathArgument="filepath"

o = open

o("filepath")  # $ MISSING: getAPathArgument="filepath"
o(file="filepath")  # $ MISSING: getAPathArgument="filepath"
