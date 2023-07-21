from trace import *
enter(__file__)

class SOURCE(object):
    @staticmethod
    def block_flow(): pass

check("SOURCE", SOURCE, SOURCE, globals()) #$ prints=SOURCE

SOURCE.block_flow()

check("SOURCE", SOURCE, SOURCE, globals())

exit(__file__)
