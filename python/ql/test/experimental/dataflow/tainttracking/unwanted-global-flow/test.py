import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# Various instances where flow is undesirable


# A global variable that starts out being not tainted, but gets tainted through a later assignment.
# In this case, we do not want flow from the tainting assignment back to the place where the value
# was used in a potentially unsafe manner.

tainted_later = NOT_TAINTED
ensure_not_tainted(tainted_later)

def write_global():
    global tainted_later
    tainted_later = TAINTED_STRING


# A global variable that starts out tainted, and is subsequently reassigned to be untainted.
# In this case we don't want flow from the first assignment to any of its uses.

initially_tainted = TAINTED_STRING
len(initially_tainted) # Some call that _could_ potentially modify `initially_tainted`
initially_tainted = NOT_TAINTED
ensure_not_tainted(initially_tainted)

def use_of_initially_tainted():
    ensure_not_tainted(initially_tainted) # FP


# A very similar case to the above, but here we _do_ want taint flow, because the initially tainted
# value is actually used before it gets reassigned to an untainted value. 

def use_of_initially_tainted2():
    ensure_tainted(initially_tainted2)

initially_tainted2 = TAINTED_STRING
use_of_initially_tainted2()
initially_tainted2 = NOT_TAINTED
ensure_not_tainted(initially_tainted2)


# Flow via global assignment

def write_tainted():
    global g
    g = TAINTED_STRING

def sink_global():
    ensure_tainted(g)

write_global()
write_tainted()
sink_global()
