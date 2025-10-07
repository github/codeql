class A:
    def __init__(self):
        self._foo = 3

class B(A):
    # BAD: _foo is shadowed by attribute A._foo
    def _foo(self):
        return 2

