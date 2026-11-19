---
category: minorAnalysis
---
* The `py/tarslip` query now detects unsafe `TarFile.extractall` calls where the `members` argument may be `None`, including calls through wrappers with a `None` default.
