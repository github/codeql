from trace import *
enter(__file__)

class SOURCE(object): pass

check("SOURCE", SOURCE, SOURCE, globals()) #$ prints=SOURCE

SOURCE.foo = 42

check("SOURCE", SOURCE, SOURCE, globals()) #$ prints=SOURCE

exit(__file__)
