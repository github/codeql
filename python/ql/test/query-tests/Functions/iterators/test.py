class Bad1:
    def __next__(self):
        return 0 

    def __iter__(self): # BAD: Iter does not return self
        yield 0 

class Good1:
    def __next__(self):
        return 0 

    def __iter__(self): # GOOD: iter returns self
        return self 

class Good2:
    def __init__(self):
        self._it = iter([0,0,0])

    def __next__(self):
        return next(self._it)

    def __iter__(self): # GOOD: iter and next are wrappers around a field
        return self._it.__iter__()

class Good3:
    def __next__(self):
        return 0

    def __iter__(self): # GOOD: this is an equivalent iterator to `self`.
        return iter(self.__next__, None)

class FalsePositive1:
    def __init__(self):
        self._it = None 

    def __next__(self):
        if self._it is None:
            self._it = iter(self)
        return next(self._it)

    def __iter__(self): # SPURIOUS, GOOD: implementation of next ensures the iterator is equivalent to the one returned by iter, but this is not detected.
        yield 0 
        yield 0