class MyRange(object):
    def __init__(self, low, high):
        self.low = low
        self.high = high

    def __iter__(self):
        return MyRangeIterator(self.low, self.high)

    def skip(self, to_skip):
        return MyRangeIterator(self.low, self.high, to_skip)

class MyRangeIterator(object):
    def __init__(self, low, high, skip=None):
        self.current = low
        self.high = high
        self.skip = skip

    def __next__(self):
        if self.current >= self.high:
            raise StopIteration
        to_return = self.current
        self.current += 1
        if self.skip and to_return in self.skip:
            return self.__next__()
        return to_return

    # Problem is fixed by uncommenting these lines
    # def __iter__(self):
    #     return self

my_range = MyRange(0,10)
x = sum(my_range) # x = 45
y = sum(my_range.skip({6,9})) # TypeError: 'MyRangeIterator' object is not iterable
