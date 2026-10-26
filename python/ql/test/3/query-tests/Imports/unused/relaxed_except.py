# In Python 2, Beta is an alias binding; in Python 3, it is an exception type.
from relaxed_except_defs import Alpha, Beta


def unparenthesized():
    try:
        pass
    except Alpha, Beta:
        raise
