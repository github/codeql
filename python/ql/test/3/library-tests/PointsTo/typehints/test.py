from typing import Optional, Set

def foo(x:Optional[int]) -> int:
    pass

def bar(s:set)->Set:
    pass


# ODASA-8075
class baz():
    pass

while True:
    baz = baz[baz]
