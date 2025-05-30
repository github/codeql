class MyRange(object):
    def __init__(self, low, high):
        self.current = low
        self.high = high

    def __iter__(self):
        return (self.current, self.high) # BAD: does not return `self`.

    def __next__(self):
        if self.current > self.high:
            return None
        self.current += 1
        return self.current - 1