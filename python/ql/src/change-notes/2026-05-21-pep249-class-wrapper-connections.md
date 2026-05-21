---
category: minorAnalysis
---
* Improved detection of SQL injection and other PEP 249 database-related vulnerabilities when a database connection is stored in a class instance attribute and accessed through a getter method or direct attribute read. For example, patterns like `self._conn = dbapi.connect(...)` in `__init__` followed by `return self._conn` in a getter method, or `MyClass()._conn`, are now correctly recognised as PEP 249 connection sources.
