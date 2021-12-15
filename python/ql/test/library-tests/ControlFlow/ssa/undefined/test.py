from outside import cond

try:
    import module1
except ImportError:
    quit()

module1

try:
    import module2
except ImportError:
    print("Error")

module2

if cond():
    x = 0

x
