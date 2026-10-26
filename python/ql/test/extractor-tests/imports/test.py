#This use to cause an extractor failure.
from module import (x 
                    as y)

try:
    import fcntl
except ImportError:
    pass

try:
    import __builtin__
except ImportError:
    import builtins as __builtin__
