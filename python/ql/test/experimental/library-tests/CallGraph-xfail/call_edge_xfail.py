import sys

# name:xfail_foo
def xfail_foo():
    print('xfail_foo')

# name:xfail_bar
def xfail_bar():
    print('xfail_bar')

def xfail_baz():
    print('xfail_baz')

# name:xfail_lambda
xfail_lambda = lambda: print('xfail_lambda')

if len(sys.argv) >= 2 and not sys.argv[1] in ['0', 'False', 'false']:
    func = xfail_foo
else:
    func = xfail_bar

# Correct usage to suppress bad annotation errors
# calls:xfail_foo calls:xfail_bar
func()
# calls:xfail_lambda
xfail_lambda()

# These are not annotated, and will give rise to unexpectedCallEdgeFound
func()
xfail_foo()
xfail_lambda()

# These are annotated wrongly, and will give rise to unexpectedCallEdgeFound

# calls:xfail_bar
xfail_foo()

# calls:xfail_bar
xfail_baz()

# The annotation is incomplete (does not include the call to xfail_bar)
# calls:xfail_foo
func()
