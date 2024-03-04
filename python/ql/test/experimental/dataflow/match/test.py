
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"


def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)


def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")

def test_guard():
    match SOURCE:
        case x if SINK(x): #$ flow="SOURCE, l:-1 -> x"
            pass

@expects(2)
def test_as_pattern():
    match SOURCE:
        case x as y:
            SINK(x) #$ flow="SOURCE, l:-2 -> x"
            SINK(y) #$ flow="SOURCE, l:-3 -> y"

def test_or_pattern():
    match SOURCE:
        # We cannot use NONSOURCE in place of "" below, since it would be seen as a variable.
        case ("" as x) | x:
            SINK(x) #$ flow="SOURCE, l:-3 -> x"

# No flow for literal pattern
def test_literal_pattern():
    match SOURCE:
        case "source" as x:
            SINK(x) #$ flow="SOURCE, l:-2 -> x" flow="'source', l:-1 -> x"

def test_capture_pattern():
    match SOURCE:
        case x:
            SINK(x) #$ flow="SOURCE, l:-2 -> x"

# No flow for wildcard pattern

class Unsafe:
    VALUE = SOURCE

def test_value_pattern():
    match SOURCE:
        case Unsafe.VALUE as x:
            SINK(x) #$ flow="SOURCE, l:-2 -> x" flow="SOURCE, l:-5 -> x"

@expects(2)
def test_sequence_pattern_tuple():
    match (NONSOURCE, SOURCE):
        case (x, y):
            SINK_F(x)
            SINK(y) #$ flow="SOURCE, l:-3 -> y"

@expects(2)
def test_sequence_pattern_list():
    match [NONSOURCE, SOURCE]:
        case [x, y]:
            SINK_F(x) #$ SPURIOUS: flow="SOURCE, l:-2 -> x"
            SINK(y) #$ flow="SOURCE, l:-3 -> y"

# Sets are excluded from sequence patterns,
#   see https://www.python.org/dev/peps/pep-0635/#sequence-patterns

@expects(2)
def test_star_pattern_tuple():
    match (NONSOURCE, SOURCE):
        case (x, *y):
            SINK_F(x)
            SINK(y[0]) #$ flow="SOURCE, l:-3 -> y[0]"

@expects(2)
def test_star_pattern_tuple_exclusion():
    match (SOURCE, NONSOURCE):
        case (x, *y):
            SINK(x) #$ flow="SOURCE, l:-2 -> x"
            SINK_F(y[0])

@expects(2)
def test_star_pattern_list():
    match [NONSOURCE, SOURCE]:
        case [x, *y]:
            SINK_F(x) #$ SPURIOUS: flow="SOURCE, l:-2 -> x"
            SINK(y[0]) #$ flow="SOURCE, l:-3 -> y[0]"

@expects(2)
def test_star_pattern_list_exclusion():
    match [SOURCE, NONSOURCE]:
        case [x, *y]:
            SINK(x) #$ flow="SOURCE, l:-2 -> x"
            SINK_F(y[0]) #$ SPURIOUS: flow="SOURCE, l:-3 -> y[0]"

@expects(2)
def test_mapping_pattern():
    match {"a": NONSOURCE, "b": SOURCE}:
        case {"a": x, "b": y}:
            SINK_F(x)
            SINK(y) #$ flow="SOURCE, l:-3 -> y"

# also tests the key value pattern
@expects(2)
def test_double_star_pattern():
    match {"a": NONSOURCE, "b": SOURCE}:
        case {"a": x, **y}:
            SINK_F(x)
            SINK(y["b"]) #$ flow="SOURCE, l:-3 -> y['b']"

@expects(2)
def test_double_star_pattern_exclusion():
    match {"a": SOURCE, "b": NONSOURCE}:
        case {"a": x, **y}:
            SINK(x) #$ flow="SOURCE, l:-2 -> x"
            SINK_F(y["b"])
            try:
                SINK_F(y["a"])
            except KeyError:
                pass

class Cell:
    def __init__(self, value):
        self.value = value

# also tests the keyword pattern
@expects(2)
def test_class_pattern():
    bad_cell = Cell(SOURCE)
    good_cell = Cell(NONSOURCE)

    match bad_cell:
        case Cell(value = x):
            SINK(x) #$ flow="SOURCE, l:-5 -> x"

    match good_cell:
        case Cell(value = x):
            SINK_F(x)
