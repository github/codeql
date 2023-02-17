# combination of refined and if_then_else

from trace import *
enter(__file__)

class SOURCE(): pass

# definition based on "random" choice in this case it will always go the the if-branch,
# but our analysis is not able to figure this out
if eval("True"):
    src = SOURCE
else:
    src = SOURCE

src.foo = 42

check("src", src, src, globals()) #$ prints=SOURCE

exit(__file__)
