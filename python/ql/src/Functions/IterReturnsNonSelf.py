class MyRange(object):
    def __init__(self, low, high):
        self.current = low
        self.high = high

    def __iter__(self):
        return self.current

    def next(self):
        if self.current > self.high:
            raise StopIteration
        self.current += 1
        return self.current - 1