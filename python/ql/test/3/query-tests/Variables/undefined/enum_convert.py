from enum import IntEnum

IntEnum._convert(
        'Maybe',
        __name__,
        lambda C: C.isupper() and C.startswith('AF_'))

__all__ = [ "Maybe", "Maybe_not" ]
