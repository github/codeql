#Incomplete ordering

class PartOrdered(object):
    def __eq__(self, other):
        return self is other

    def __ne__(self, other):
        return self is not other

    def __hash__(self):
        return id(self)

    def __lt__(self, other):
        return False

#Don't blame a sub-class for super-class's sins.
class DerivedPartOrdered(PartOrdered):
    pass