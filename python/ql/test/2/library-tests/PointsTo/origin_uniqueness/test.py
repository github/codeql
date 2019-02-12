

#Couple of tests for cases where multiple origins had occurred.

import module1
from module1 import a
from module2 import *

a
module1.b
x

class C:
    pass

c = type(
        C())
t = type(
         C)
i = type(
         7)