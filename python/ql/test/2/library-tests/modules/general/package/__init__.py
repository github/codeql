
a = 1
b = 2
c = 3

#Implicit relative import
from helper import d

#Explicit relative import
from .helper import g

from .assistant import f

#This will be an implicit relative import (in Python 2)
import helper
