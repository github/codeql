# Import aliases. All bound names below currently lack a CFG node.

import os  # $ MISSING: cfgdefines=os
import os.path  # $ MISSING: cfgdefines=os
import os as o  # $ MISSING: cfgdefines=o
from os import path  # $ MISSING: cfgdefines=path
from os import path as p  # $ MISSING: cfgdefines=p
from os import sep, linesep  # $ MISSING: cfgdefines=sep MISSING: cfgdefines=linesep
from os import (
    getcwd,  # $ MISSING: cfgdefines=getcwd
    getcwdb,  # $ MISSING: cfgdefines=getcwdb
)
