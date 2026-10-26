# This file showcases how imports work with `__all__`.
#
# TL;DR; in `from <module> import *`, if `__all__` is defined in `<module>`, then only
# the names in `__all__` will be imported -- otherwise all names that doesn't begin with
# an underscore will be imported.
#
# If `__all__` is defined, `__all__` must be a sequence for `from <module> import *` to work.
#
# https://docs.python.org/3/reference/simple_stmts.html#the-import-statement
# https://docs.python.org/3/glossary.html#term-sequence

print("import *")
print("---")

from no_all import *
print("no_all.py")
print("  foo={!r}".format(foo))
print("  bar={!r}".format(bar))
print("  baz={!r}".format(baz))
try:
    print("  _qux={!r}".format(_qux))
except NameError:
    print("  _qux not imported")
del foo, bar, baz

from all_list import *
print("all_list.py")
print("  foo={!r}".format(foo))
print("  bar={!r}".format(bar))
try:
    print("  baz={!r}".format(baz))
except NameError:
    print("  baz not imported")
del foo, bar

from all_tuple import *
print("all_tuple.py")
print("  foo={!r}".format(foo))
print("  bar={!r}".format(bar))
try:
    print("  baz={!r}".format(baz))
except NameError:
    print("  baz not imported")
del foo, bar

from all_dynamic import *
print("all_dynamic.py")
print("  foo={!r}".format(foo))
print("  bar={!r}".format(bar))
try:
    print("  baz={!r}".format(baz))
except NameError:
    print("  baz not imported")
del foo, bar

from all_indirect import *
print("all_indirect.py")
print("  foo={!r}".format(foo))
print("  bar={!r}".format(bar))
try:
    print("  baz={!r}".format(baz))
except NameError:
    print("  baz not imported")
del foo, bar

# Example of wrong definition of `__all__`, where it is not a sequence.
try:
    from all_set import *
except TypeError as e:
    assert str(e) == "'set' object does not support indexing"
    print("from all_set import * could not be imported:", e)

print("")
print("Direct reference on module")
print("---")
# Direct reference always works, no matter how `__all__` is set.
import no_all
import all_list
import all_tuple
import all_dynamic
import all_indirect
import all_set

for mod in [no_all, all_list, all_tuple, all_dynamic, all_indirect, all_set]:
    print("{}.py".format(mod.__name__))
    print("  foo={!r}".format(mod.foo))
    print("  bar={!r}".format(mod.bar))
    print("  baz={!r}".format(mod.baz))

print("\nspecial: no_all._qux={!r}".format(no_all._qux))
