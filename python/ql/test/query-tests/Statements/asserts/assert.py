import sys
import six

def _f():
    assert (yield 3) # $ Alert[py/side-effect-in-assert]
    x = [ 1 ]
    assert len(x)   #Call without side-effects
    assert sys.exit(1) # $ Alert[py/side-effect-in-assert] #Call with side-effects
    expected_types = (Response, six.text_type, six.binary_type)
    assert isinstance(obj, expected_types), \
        "obj must be %s, not %s" % (
            " or ".join(t.__name__ for t in expected_types),
            type(obj).__name__)

def assert_tuple(x, y):
    assert () # $ Alert[py/asserts-tuple]
    assert (x, y) # $ Alert[py/asserts-tuple]














def error_assert_true(x):
    if x:
        assert True, "Bad" # $ Alert[py/assert-literal-constant]
    else:
        assert True # $ Alert[py/assert-literal-constant]

def error_assert_false(x):
    if x:
        assert False, "Bad" # $ Alert[py/assert-literal-constant]

def error_assert_zero(x):
    if x:
        assert 0, "Bad" # $ Alert[py/assert-literal-constant]

def error_assert_one(x):
    if x:
        assert 1, "Bad" # $ Alert[py/assert-literal-constant]

def error_assert_empty_string(x):
    if x:
        assert "", "Bad" # $ Alert[py/assert-literal-constant]

def error_assert_nonempty_string(x):
    if x:
        assert "X", "Bad" # $ Alert[py/assert-literal-constant]
    else:
        assert "X" # $ Alert[py/assert-literal-constant]

def ok_assert_false(x):
    if x:
        assert 0==1, "Ok"

from unittest import TestCase


class MyTest(TestCase):
    def test_ok_assert_in_test(self, x):
        if x:
            assert False, "Ok"

def ok_assert_in_final_branch3(x):
    if foo(x):
        pass
    elif bar(x):
        pass
    elif quux(x):
        pass
    else:
        assert False, "Ok"

def ok_assert_in_final_branch2(x):
    if foo(x):
        pass
    elif bar(x):
        pass
    else:
        assert False, "Ok"

def error_assert_in_final_branch1(x):
    if foo(x):
        pass
    else:
        assert False, "Error" # $ Alert[py/assert-literal-constant]

def error_assert_in_intermediate_branch(x):
    if foo(x):
        pass
    elif bar(x):
        pass
    elif quux(x):
        assert False, "Error" # $ Alert[py/assert-literal-constant]
    elif yks(x):
        pass
    else:
        pass
