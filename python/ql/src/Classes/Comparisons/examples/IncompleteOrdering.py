class A:
    def __init__(self, i):
        self.i = i

    # BAD: le is not defined, so `A(1) <= A(2)` would result in an error.
    def __lt__(self, other):
        return self.i < other.i
    