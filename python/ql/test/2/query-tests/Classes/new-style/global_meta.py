

__metaclass__ = type

class NewStyleEvenForPython2:

    __slots__ = [ "ok" ]

class OkToUseSuper(NewStyleEvenForPython2):

    def __init__(self):
        super(OkToUseSuper, self).__init__()

