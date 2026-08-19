---
category: fix
---
* Fixed the extraction of PEP 758 `except A, B:` clauses by the default (non-tree-sitter) Python parser. Previously the second exception type was extracted as a Python 2 style alias binding, so it was recorded as a `Store` rather than a use. This caused false positives from queries that reason about whether a name is used, such as `py/unused-import`.
