#! /usr/bin/env python3
"""
A slightly complicated test setup. I wanted to both make sure I captured
the semantics of Python and also the fact that the kinds of global flow
we expect to see are indeed present.

The code is executable, and prints out both when the execution reaches
certain files, and also what values are assigned to the various
attributes that are referenced throughout the program. These values are
validated in the test as well.

My original version used introspection to avoid referencing attributes
directly (thus enabling better error diagnostics), but unfortunately
that made it so that the model couldn't follow what was going on.

The current setup is a bit clunky (and Python's scoping rules makes it
especially so -- cf. the explicit calls to `globals` and `locals`), but
I think it does the job okay.
"""

from __future__ import print_function
import sys
from trace import *
enter(__file__)

# A simple import. Binds foo to the foo module
import foo #$ imports=foo as=foo
check("foo.foo_attr", foo.foo_attr, "foo_attr", globals()) #$ prints=foo_attr

# Private attributes are still accessible.
check("foo.__private_foo_attr", foo.__private_foo_attr, "__private_foo_attr", globals()) #$ prints=__private_foo_attr

# An aliased import, binding foo to foo_alias
import foo as foo_alias #$ imports=foo as=foo_alias
check("foo_alias.foo_attr", foo_alias.foo_attr, "foo_attr", globals()) #$ prints=foo_attr

# A reference to a reexported module
check("foo.bar_reexported", foo.bar_reexported, "<module bar>", globals()) #$ prints="<module bar>"
check("foo.bar_reexported.bar_attr", foo.bar_reexported.bar_attr, "bar_attr", globals()) #$ prints=bar_attr

# A simple "import from" statement.
from bar import bar_attr
check("bar_attr", bar_attr, "bar_attr", globals()) #$ prints=bar_attr

# Importing an attribute from a subpackage of a package.
from package.subpackage import subpackage_attr
check("subpackage_attr", subpackage_attr, "subpackage_attr", globals()) #$ prints=subpackage_attr

# Importing a package attribute under an alias.
from package import package_attr as package_attr_alias
check("package_attr_alias", package_attr_alias,  "package_attr", globals()) #$ prints=package_attr

# Importing a subpackage under an alias.
from package import subpackage as aliased_subpackage #$ imports=package.subpackage.__init__ as=aliased_subpackage
check("aliased_subpackage.subpackage_attr", aliased_subpackage.subpackage_attr, "subpackage_attr", globals()) #$ prints=subpackage_attr

def local_import():
    # Same as above, but in a local scope.
    import package.subpackage as local_subpackage #$ imports=package.subpackage.__init__ as=local_subpackage
    check("local_subpackage.subpackage_attr", local_subpackage.subpackage_attr, "subpackage_attr", locals()) #$ prints=subpackage_attr

local_import()

# Importing a subpacking using `import` and binding it to a name.
import package.subpackage as aliased_subpackage #$ imports=package.subpackage.__init__ as=aliased_subpackage
check("aliased_subpackage.subpackage_attr", aliased_subpackage.subpackage_attr, "subpackage_attr", globals()) #$ prints=subpackage_attr

# Importing without binding instead binds the top level name.
import package.subpackage #$ imports=package.__init__ as=package
check("package.package_attr", package.package_attr, "package_attr", globals()) #$ prints=package_attr

# Deep imports
import package.subpackage.submodule #$ imports=package.__init__ as=package
check("package.subpackage.submodule.submodule_attr", package.subpackage.submodule.submodule_attr, "submodule_attr", globals()) #$ prints=submodule_attr


if sys.version_info[0] == 3:
    # Importing from a namespace module.
    from namespace_package.namespace_module import namespace_module_attr
    check("namespace_module_attr", namespace_module_attr, "namespace_module_attr", globals()) #$ prints3=namespace_module_attr


from attr_clash import clashing_attr, non_clashing_submodule #$ imports=attr_clash.clashing_attr as=clashing_attr imports=attr_clash.non_clashing_submodule as=non_clashing_submodule
check("clashing_attr", clashing_attr, "clashing_attr", globals()) #$ prints=clashing_attr SPURIOUS: prints="<module attr_clash.clashing_attr>"
check("non_clashing_submodule", non_clashing_submodule, "<module attr_clash.non_clashing_submodule>", globals()) #$ prints="<module attr_clash.non_clashing_submodule>"


# check that import * from an __init__ file works
from package.subpackage2 import *
check("subpackage2_attr", subpackage2_attr, "subpackage2_attr", globals()) #$ prints=subpackage2_attr

# check that definitions from within if-then-else are found
from if_then_else import if_then_else_defined
check("if_then_else_defined", if_then_else_defined, "if_defined", globals()) #$ prints=if_defined prints=else_defined_1 prints=else_defined_2

exit(__file__)

print()

if status() == 0:
    print("PASS")
else:
    sys.exit("FAIL")
