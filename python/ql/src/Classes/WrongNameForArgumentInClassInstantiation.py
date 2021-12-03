class Point(object):
    def __init__(self, x, y):
        self.x = x
        self.y = y

p = Point(x=1, yy=2) # TypeError: 'yy' is not a valid keyword argument
