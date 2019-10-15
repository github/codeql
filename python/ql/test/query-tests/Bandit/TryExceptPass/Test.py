# bad
try:
    a = 1
except:
    pass


# bad
try:
    a = 1
except Exception:
    pass


# bad
try:
    a = 1
except ZeroDivisionError:
    pass
except:
    a = 2


# good
try:
    a = 1
except:
    a = 2


# silly, but ok
try:
    a = 1
except:
    pass
    a = 2
