---
category: minorAnalysis
---

* The `py/undefined-export` query no longer flags names listed in `__all__` when a Python 3.7 or newer module has a callable module-level `__getattr__` to provide attributes dynamically.
