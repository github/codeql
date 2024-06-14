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

import used_in_doctest

def f():
    '''
    >>> unrelated
    >>> used_in_doctest.thing() == f()
    True
    '''
    return 5

#Used in Python2 type hint
import typing

foo = None # type: typing.Optional[int]


# OK since the import statement is never executed
if False:
    import never_imported

# OK since the imported module is used in a forward-referenced type annotation.
import only_used_in_parameter_annotation

def func(x: 'Optional[only_used_in_parameter_annotation]'):
    pass

import only_used_in_annotated_assignment

var : 'Optional[only_used_in_annotated_assignment]' = 5

import used_in_return_type

def look_at_my_return_type() -> 'Optional[used_in_return_type]':
    pass

# Uses inside strings appearing as subexpressions of an annotation:

import subexpression_parameter_annotation

def bar(x: Optional['subexpression_parameter_annotation']):
    pass

import subexpression_assignment_annotation

var3 : Optional['subexpression_assignment_annotation'] = None

import subexpression_return_type

def baz() -> Optional['subexpression_return_type']:
    pass


from pytest_fixtures import not_a_fixture  # BAD
from pytest_fixtures import fixture, wrapped_fixture  # GOOD (pytest fixtures are used implicitly by pytest)
from pytest_fixtures import session_fixture, wrapped_autouse_fixture  # GOOD (pytest fixtures are used implicitly by pytest)
