# a copy of `has_defined_all.py` that is imported by `has_defined_all_indirection.py`
# with its' own names such that we can check both `import *` without any cross-talk
from trace import *
enter(__file__)

all_defined_foo_copy = "all_defined_foo_copy"
all_defined_bar_copy = "all_defined_bar_copy"

__all__ = ["all_defined_foo_copy"]

exit(__file__)
