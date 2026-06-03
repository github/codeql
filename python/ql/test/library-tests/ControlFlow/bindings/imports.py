# Import aliases — all bound names below are now reachable via the new
# CFG's `ImportStmt` wrapper.

import os  # $ cfgdefines=os
import os.path  # $ cfgdefines=os
import os as o  # $ cfgdefines=o
from os import path  # $ cfgdefines=path
from os import path as p  # $ cfgdefines=p
from os import sep, linesep  # $ cfgdefines=sep cfgdefines=linesep
from os import (
    getcwd,  # $ cfgdefines=getcwd
    getcwdb,  # $ cfgdefines=getcwdb
)

