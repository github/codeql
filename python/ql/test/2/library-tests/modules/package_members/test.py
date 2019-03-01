#Importing the package will execute its __init__.py module, filling in the namespace for the package.

import test_package
import sys

#These values now exist
test_package.a
test_package.b
test_package.c
#But this does not...
#test_package.d

#This doesn't exist either
#test_package.module2

#We can't do this as d is not a module
#from test_package import d

#When we do this test_package.module2 becomes defined
from test_package import module2

#Now these are defined
test_package.module2
module2

import test_package.module3

#Now this are defined
test_package.module3

_private = 1
