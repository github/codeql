from trace import *
enter(__file__)

class SOURCE(object):
    @staticmethod
    def block_flow(): pass

check("SOURCE", SOURCE, SOURCE, globals()) #$ prints=SOURCE

if eval("False"):
    # With our current import resolution, this value for SOURCE will be considered to be
    # a valid value at the end of this module, because it's the end of a use-use flow.
    # This is clearly wrong, so our import resolution is a bit too generous on what is
    # exported
    print(SOURCE)
    raise Exception()

SOURCE.block_flow()

check("SOURCE", SOURCE, SOURCE, globals())

exit(__file__)
