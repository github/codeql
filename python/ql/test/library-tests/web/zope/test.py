
from zope.interface import Interface, implementer

class IThing(Interface):
    pass


@implementer(IThing)
class Thing(object):
    pass

implementer
IThing
Thing
