import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# Various instances where flow is undesirable

tainted = NOT_TAINTED
ensure_not_tainted(tainted)

def write_global():
    global tainted
    tainted = TAINTED_STRING

tainted2 = TAINTED_STRING
len(tainted2)
tainted2 = NOT_TAINTED
ensure_not_tainted(tainted2)

def use_of_tainted2():
    global tainted2
    tainted2 = NOT_TAINTED

# Flow via global assigment

def write_tainted():
    global g
    g = TAINTED_STRING

def sink_global():
    ensure_tainted(g)

write_tainted()
sink_global()
