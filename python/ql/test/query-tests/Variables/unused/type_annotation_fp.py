# FP Type annotation counts as redefinition
# See https://github.com/Semmle/ql/issues/2652

def type_annotation(x):
    foo = 5
    if x:
        foo : int
        do_stuff_with(foo)
    else:
        foo : float
        do_other_stuff_with(foo)
