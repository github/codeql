A testcase observed in real code, where mixing `from .this import that` with `from .other import *` (in that order) causes import resolution to not work properly.

This needs to be in a separate folder, since using relative imports requires a valid top-level package. We emulate real extractor behavior using `-R` extractor option.

From this directory, you can run the code with `python -m pkg.use`.
