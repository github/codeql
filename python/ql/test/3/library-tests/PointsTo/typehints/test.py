from typing import Optional, Set

def foo(x:Optional[int]) -> int:
    pass

def bar(s:set)->Set:
    pass

t1 = Optional[Optional[int]]
t2 = Optional[int][int]

# ODASA-8075
# Commented out until the fix has been pushed to LGTM.com
#class baz():
#    pass
#
#while True:
#    baz = baz[baz]
