# potentially crashing cycles
import module2
import module3

a1 = module2.a2
b1 = 2

# bad style cycles
import module4
def foo():
    import module5

# okay, because some of the cycle is not top level
import module6

# OK because this import occurs after relevant definition (a1)
import module8

#OK because cycle is guarded by `if False:`
from module10 import x


