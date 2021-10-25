class Point(object):
    def __init__(self, x, y):
        self.x = x
        self.y = y

p = Point(1)      # TypeError: too few arguments
p = Point(1,2,3)  # TypeError: too many arguments
