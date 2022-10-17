#! /usr/bin/env python3

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

if sys.version_info[0] >= 3:
    # Importing from a namespace module.
    from namespace_package.namespace_module import namespace_module_attr
    check("namespace_module_attr", namespace_module_attr, "namespace_module_attr", globals()) #$ prints=namespace_module_attr

exit(__file__)

print()

if status() == 0:
    print("PASS")
else:
    print("FAIL")
