
#Defined in metaclass
class Meta(type):

    def __init__(cls, name, bases, dct):
        type.__init__(cls, name, bases, dct)
        cls.defined_in_meta = 1

class HasMeta(object):

    __metaclass__ = Meta

    def ok5(self):
        return self.defined_in_meta

