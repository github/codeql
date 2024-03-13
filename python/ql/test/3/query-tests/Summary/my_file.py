"""
module level docstring

is not included
"""
# this line is not code

# `tty` was chosen for stability over python versions (so we don't get diffrent results
# on different computers, that has different versions of Python).
#
# According to https://github.com/python/cpython/tree/master/Lib (at 2021-04-23) `tty`
# was last changed in 2001, so chances of this being changed in the future are slim.
import tty

s = """
all these lines are code
"""

print(s)

def func():
    """
    this string is a doc-string. Although the module-level docstring is not considered
    code, this one apparently is ¯\_(ツ)_/¯
    """
    pass
