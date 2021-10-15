
from __future__ import print_function
import sys

def bar(cond):
    if cond:
        fail("cond true")


def fail(message, *args):
    print('Error:', message % args, file=sys.stderr)
    sys.exit(1)

def foo(cond):
    bar()

# To get the FP result reported in ODASA-6418, 
#bar must be called directly (not transitively) from the module scope
bar(unknown())

#The following do not trigger the bug
#foo(unknown())
#pass

