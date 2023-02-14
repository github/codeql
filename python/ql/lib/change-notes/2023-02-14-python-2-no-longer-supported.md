---
category: breaking
---
- Python 2 is no longer supported for extracting databases using the CodeQL CLI. As a consequence,
  the previously deprecated support for `pyxl` and `spitfire` templates has also been removed. When
  extracting Python 2 code, having Python 2 installed is still recommended, as this ensures the
  correct version of the Python standard library is extracted.
