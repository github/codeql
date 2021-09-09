import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import *

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"  #$ importTimeFlow="ModuleVariableNode for Global Variable NONSOURCE in Module multiphase"
SOURCE = "source"  #$ importTimeFlow="ModuleVariableNode for Global Variable SOURCE in Module multiphase"


def is_source(x):  #$ importTimeFlow="ModuleVariableNode for Global Variable is_source in Module multiphase"
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):  #$ importTimeFlow="ModuleVariableNode for Global Variable SINK in Module multiphase"
    if is_source(x):  #$ runtimFlow="ModuleVariableNode for Global Variable is_source in Module multiphase, l:-17 -> is_source"
        print("OK")  #$ runtimFlow="ModuleVariableNode for Global Variable print in Module multiphase, l:-18 -> print"
    else:
        print("Unexpected flow", x)  #$ runtimFlow="ModuleVariableNode for Global Variable print in Module multiphase, l:-20 -> print"


def SINK_F(x):
    if is_source(x):  #$ runtimFlow="ModuleVariableNode for Global Variable is_source in Module multiphase, l:-24 -> is_source"
        print("Unexpected flow", x)  #$ runtimFlow="ModuleVariableNode for Global Variable print in Module multiphase, l:-25 -> print"
    else:
        print("OK")  #$ runtimFlow="ModuleVariableNode for Global Variable print in Module multiphase, l:-27 -> print"

def set_foo():  #$ importTimeFlow="ModuleVariableNode for Global Variable set_foo in Module multiphase"
    global foo
    foo = SOURCE  #$ runtimFlow="ModuleVariableNode for Global Variable SOURCE in Module multiphase, l:-31 -> SOURCE" MISSING:importTimeFlow="ModuleVariableNode for Global Variable foo in Module multiphase"

foo = NONSOURCE  #$ importTimeFlow="ModuleVariableNode for Global Variable foo in Module multiphase"
set_foo()

@expects(2)
def test_phases():
    global foo
    SINK(foo)  #$ runtimFlow="ModuleVariableNode for Global Variable SINK in Module multiphase, l:-39 -> SINK" runtimFlow="ModuleVariableNode for Global Variable foo in Module multiphase, l:-39 -> foo"
    foo = NONSOURCE  #$ runtimFlow="ModuleVariableNode for Global Variable NONSOURCE in Module multiphase, l:-40 -> NONSOURCE"
    set_foo()  #$ runtimFlow="ModuleVariableNode for Global Variable set_foo in Module multiphase, l:-41 -> set_foo"
    SINK(foo)  #$ runtimFlow="ModuleVariableNode for Global Variable SINK in Module multiphase, l:-42 -> SINK" runtimFlow="ModuleVariableNode for Global Variable foo in Module multiphase, l:-42 -> foo"
