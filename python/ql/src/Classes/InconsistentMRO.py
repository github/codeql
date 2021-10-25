class X(object):
    def __init__(self):
        print("X")
class Y(object,X):
    def __init__(self):
        print("Y")