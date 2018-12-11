#Test for ODASA-6418

import sys

def bar(cond):
    if cond:
        fail("cond true")


def fail(message, *args):
    write('Error:', message % args, file=sys.stderr)
    sys.exit(1)

def foo(cond):
    bar()

# To get the FP result reported in ODASA-6418, the following must hold:
#bar must be called directly (not transitively) from the module scope
#bar must precede fail
#The call to bar must follow fail
bar(unknown())

#The following do not trigger the bug
#foo(unknown())
#pass

