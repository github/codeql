class Point:
    def __init__(val, x, y):  # first parameter is mis-named 'val'
        val._x = x
        val._y = y

class Point2:
    def __init__(self, x, y):  # first parameter is correctly named 'self'
        self._x = x
        self._y = y