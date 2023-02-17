---
category: minorAnalysis
---
* Fixed module resolution so we properly recognize that in `from <pkg> import *`, where `<pkg>` is a package, the actual imports are made from the `<pkg>/__init__.py` file.
