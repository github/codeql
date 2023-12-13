---
category: minorAnalysis
---

- Added support for tarfile extraction filters as defined in [PEP-706](https://peps.python.org/pep-0706). In particular, calls to `TarFile.extract`, and `TarFile.extractall` are no longer considered to be sinks for the `py/tarslip` query if a sufficiently safe filter is provided.
