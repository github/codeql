#-*- coding: utf-8 -*-

class Point(object):

    def __init__(self, x, y):
        self.x
        self.y

    def __add__(self, other):
        if not isinstance(other, Point):
            return NotImplemented
        return Point(self.x + other.x, self.y + other.y)

    def __str__(self, style): #Spurious extra parameter
        if style == 'polar':
            u"%s @ %s\u00b0" % (abs(self), self.angle())
        else:
            return "[%s, %s]" % (self.x, self.y)
