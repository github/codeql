
class Abstract(object):

    def wrong(self):
        # Will raise a TypeError
        raise NotImplemented()

    def right(self):
        raise NotImplementedError()
