import typing


class OverloadedInit:
    @typing.overload
    def __init__(self, x: int) -> None: ...

    @typing.overload
    def __init__(self, x: str, y: str) -> None: ...

    def __init__(self, x, y=None):
        pass

OverloadedInit(1) # $ init=OverloadedInit.__init__:11 SPURIOUS: init=OverloadedInit.__init__:6 init=OverloadedInit.__init__:9
OverloadedInit("a", "b") # $ init=OverloadedInit.__init__:11 SPURIOUS: init=OverloadedInit.__init__:6 init=OverloadedInit.__init__:9


from typing import overload


class OverloadedInitFromImport:
    @overload
    def __init__(self, x: int) -> None: ...

    @overload
    def __init__(self, x: str, y: str) -> None: ...

    def __init__(self, x, y=None):
        pass

OverloadedInitFromImport(1) # $ init=OverloadedInitFromImport.__init__:28 SPURIOUS: init=OverloadedInitFromImport.__init__:23 init=OverloadedInitFromImport.__init__:26
OverloadedInitFromImport("a", "b") # $ init=OverloadedInitFromImport.__init__:28 SPURIOUS: init=OverloadedInitFromImport.__init__:23 init=OverloadedInitFromImport.__init__:26


class NoOverloads:
    def __init__(self, x):
        pass

NoOverloads(1) # $ init=NoOverloads.__init__:36
