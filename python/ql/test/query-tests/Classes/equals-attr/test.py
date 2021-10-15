
class GenericEquality(object):

    def __eq__(self, other):
        if type(other) is not type(self):
            return False
        for attr in self.__dict__:
            if getattr(other, attr) != getattr(self, attr):
                return False
        return True


class AddAttributes(GenericEquality):

    def __init__(self, args):
        self.a, self.b = args
