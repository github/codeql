TOKEN_0 = 0
TOKEN_1 = 1
TOKEN_2 = 2
TOKEN_3 = 3
TOKEN_4 = 4
TOKEN_5 = 5

__all__ = [ "TOKEN_0" ]

for i in range(1,6):
    __all__.append("TOKEN_%d" % i)
