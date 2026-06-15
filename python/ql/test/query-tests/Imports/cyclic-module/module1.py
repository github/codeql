# potentially crashing cycles
import module2
import module3 # $ Alert[py/cyclic-import]

a1 = module2.a2 # $ Alert[py/unsafe-cyclic-import]
b1 = 2

# bad style cycles
import module4 # $ Alert[py/cyclic-import]
def foo():
    import module5 # $ Alert[py/cyclic-import]

# okay, because some of the cycle is not top level
import module6 # $ Alert[py/cyclic-import]

# OK because this import occurs after relevant definition (a1)
import module8 # $ Alert[py/cyclic-import]

#OK because cycle is guarded by `if False:`
from module10 import x


