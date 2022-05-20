import sys  #$ importTimeFlow="ImportExpr -> GSSA Variable sys"
import os  #$ importTimeFlow="ImportExpr -> GSSA Variable os"

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects #$ importTimeFlow="ImportMember -> GSSA Variable expects"

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"  #$ importTimeFlow="'not a source' -> GSSA Variable NONSOURCE"
SOURCE = "source"  #$ importTimeFlow="'source' -> GSSA Variable SOURCE"


def is_source(x):  #$ importTimeFlow="FunctionExpr -> GSSA Variable is_source"
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):  #$ importTimeFlow="FunctionExpr -> GSSA Variable SINK"
    if is_source(x):  #$ runtimeFlow="ModuleVariableNode for multiphase.is_source, l:-17 -> is_source"
        print("OK")  #$ runtimeFlow="ModuleVariableNode for multiphase.print, l:-18 -> print"
    else:
        print("Unexpected flow", x)  #$ runtimeFlow="ModuleVariableNode for multiphase.print, l:-20 -> print"


def SINK_F(x):  #$ importTimeFlow="FunctionExpr -> GSSA Variable SINK_F"
    if is_source(x):  #$ runtimeFlow="ModuleVariableNode for multiphase.is_source, l:-24 -> is_source"
        print("Unexpected flow", x)  #$ runtimeFlow="ModuleVariableNode for multiphase.print, l:-25 -> print"
    else:
        print("OK")  #$ runtimeFlow="ModuleVariableNode for multiphase.print, l:-27 -> print"

def set_foo():  #$ importTimeFlow="FunctionExpr -> GSSA Variable set_foo"
    global foo
    foo = SOURCE  #$ runtimeFlow="ModuleVariableNode for multiphase.SOURCE, l:-31 -> SOURCE" # missing final definition of foo

foo = NONSOURCE  #$ importTimeFlow="NONSOURCE -> GSSA Variable foo"
set_foo()

@expects(2)
def test_phases():  #$ importTimeFlow="expects(..)(..), l:-1 -> GSSA Variable test_phases"
    global foo
    SINK(foo)  #$ runtimeFlow="ModuleVariableNode for multiphase.SINK, l:-39 -> SINK" runtimeFlow="ModuleVariableNode for multiphase.foo, l:-39 -> foo"
    foo = NONSOURCE  #$ runtimeFlow="ModuleVariableNode for multiphase.NONSOURCE, l:-40 -> NONSOURCE"
    set_foo()  #$ runtimeFlow="ModuleVariableNode for multiphase.set_foo, l:-41 -> set_foo"
    SINK(foo)  #$ runtimeFlow="ModuleVariableNode for multiphase.SINK, l:-42 -> SINK" runtimeFlow="ModuleVariableNode for multiphase.foo, l:-42 -> foo"
