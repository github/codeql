#Multiple imports on a single line
import module1, module2

#Cyclic import

import cycle

#Top level cyclic import

import top_level_cycle

#Import shadowed by loop variable

import module

for module in range(10):
    print(module)

#Import * used

from module import *
from module_without_all import *

#Unused import

from module2 import func1
from module2 import func2

module1.func
func1

#Duplicate import
import module1
import module2

#OK -- Import used in epytext documentation.
import used_in_docs

#  L{used_in_docs}

#OK -- Used in class.
import used_in_class

class C(object):

    used_in_class = used_in_class

#OK unused imports -- ODASA-3978
from module2 import func3 as _
from module2 import func3 as unused_but_ok
from module2 import func3 as _________

class Foo(object):
    from bar import baz
    def __init__(self):
        self.foo = self.baz()

#OK duplicate import -- Different name
import module1 as different

#Use it
different

# FP reported in https://github.com/github/codeql/issues/4003
from module_that_does_not_exist import *
