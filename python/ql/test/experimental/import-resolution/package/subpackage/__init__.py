from trace import *
enter(__file__)

subpackage_attr = "subpackage_attr"

# Importing an attribute from the parent package.
from .. import attr_used_in_subpackage as imported_attr
check("imported_attr", imported_attr,  "attr_used_in_subpackage", globals()) #$ prints=attr_used_in_subpackage

# Importing an irrelevant attribute from a sibling module binds the name to the module.
from .submodule import irrelevant_attr
check("submodule.submodule_attr", submodule.submodule_attr, "submodule_attr", globals()) #$ MISSING:prints=submodule_attr

exit(__file__)
