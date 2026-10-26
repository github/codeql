from typing import Optional, Set

def foo(x:Optional[int]) -> int:
    pass

def bar(s:set)->Set:
    pass

t1 = Optional[Optional[int]]
t2 = Optional[int][int]

class baz():
    pass

while True:
    baz = baz[baz]
