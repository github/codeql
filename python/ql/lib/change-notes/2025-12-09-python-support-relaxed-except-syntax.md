---
category: feature
---
* The extractor now supports the new, relaxed syntax `except A, B, C: ...` (which would previously have to be written as `except (A, B, C): ...`) as defined in [PEP-758](https://peps.python.org/pep-0758/). This may cause changes in results for code that uses Python 2-style exception binding (`except Foo, e: ...`). The more modern format, `except Foo as e: ...` (available since Python 2.6) is unaffected.
