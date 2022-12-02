from trace import *
enter(__file__)

# A simple attribute. Used in main.py
foo_attr = "foo_attr"

# A private attribute. Accessible from main.py despite this.
__private_foo_attr = "__private_foo_attr"

# A reexport of bar under a new name. Used in main.py
import bar as bar_reexported #$ imports=bar as=bar_reexported
check("bar_reexported.bar_attr", bar_reexported.bar_attr, "bar_attr", globals()) #$ prints=bar_attr

exit(__file__)
