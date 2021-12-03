import zope.interface

#ODASA-6062
class Z(zope.interface.Interface):

    def yes(arg):
        pass

class NotZ(object):

    def no(self):
        pass
