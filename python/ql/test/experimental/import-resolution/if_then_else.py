from trace import *
enter(__file__)

# definition based on "random" choice in this case it will always go the the if-branch,
# but our analysis is not able to figure this out
if eval("True"):
    if_then_else_defined = "if_defined"
else:
    # we also check that nested if-then-else works, it would be easy to accidentally
    # only support _one_ level of nesting.
    if eval("True"):
        if_then_else_defined = "else_defined_1"
    else:
        if_then_else_defined = "else_defined_2"

exit(__file__)
