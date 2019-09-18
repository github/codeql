class IncompleteOrdering(object):
    def __init__(self, i):
        self.i = i

    def __lt__(self, other):
        return self.i < other.i