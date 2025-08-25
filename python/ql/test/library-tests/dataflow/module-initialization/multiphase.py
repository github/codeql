import sys  #$ importTimeFlow="ImportExpr -> sys"
import os  #$ importTimeFlow="ImportExpr -> os"

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects #$ importTimeFlow="ImportMember -> expects"

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"  #$ importTimeFlow="'not a source' -> NONSOURCE"
SOURCE = "source"  #$ importTimeFlow="'source' -> SOURCE"


def is_source(x):  #$ importTimeFlow="FunctionExpr -> is_source"
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):  #$ importTimeFlow="FunctionExpr -> SINK"
    if is_source(x):  #$ runtimeFlow="ModuleVariableNode in Module multiphase for is_source, l:-17 -> is_source"
        print("OK")  #$ runtimeFlow="ModuleVariableNode in Module multiphase for print, l:-18 -> print"
    else:
        print("Unexpected flow", x)  #$ runtimeFlow="ModuleVariableNode in Module multiphase for print, l:-20 -> print"


def SINK_F(x):  #$ importTimeFlow="FunctionExpr -> SINK_F"
    if is_source(x):  #$ runtimeFlow="ModuleVariableNode in Module multiphase for is_source, l:-24 -> is_source"
        print("Unexpected flow", x)  #$ runtimeFlow="ModuleVariableNode in Module multiphase for print, l:-25 -> print"
    else:
        print("OK")  #$ runtimeFlow="ModuleVariableNode in Module multiphase for print, l:-27 -> print"

def set_foo():  #$ importTimeFlow="FunctionExpr -> set_foo"
    global foo
    foo = SOURCE  #$ runtimeFlow="ModuleVariableNode in Module multiphase for SOURCE, l:-31 -> SOURCE" # missing final definition of foo

foo = NONSOURCE  #$ importTimeFlow="NONSOURCE -> foo"
set_foo()

@expects(2)
def test_phases():  #$ importTimeFlow="expects(..)(..), l:-1 -> test_phases"
    global foo
    SINK(foo)  #$ runtimeFlow="ModuleVariableNode in Module multiphase for SINK, l:-39 -> SINK" runtimeFlow="ModuleVariableNode in Module multiphase for foo, l:-39 -> foo"
    foo = NONSOURCE  #$ runtimeFlow="ModuleVariableNode in Module multiphase for NONSOURCE, l:-40 -> NONSOURCE"
    set_foo()  #$ runtimeFlow="ModuleVariableNode in Module multiphase for set_foo, l:-41 -> set_foo"
    SINK(foo)  #$ runtimeFlow="ModuleVariableNode in Module multiphase for SINK, l:-42 -> SINK" runtimeFlow="ModuleVariableNode in Module multiphase for foo, l:-42 -> foo"
