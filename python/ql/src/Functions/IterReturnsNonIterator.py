class MyRange(object):
    def __init__(self, low, high):
        self.current = low
        self.high = high

    def __iter__(self):
        return self

#Fixed version
class MyRange(object):
    def __init__(self, low, high):
        self.current = low
        self.high = high

    def __iter__(self):
        while self.current < self.high:
            yield self.current
            self.current += 1
