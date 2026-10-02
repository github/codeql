---
category: fix
---

- Fixed a bug in the Python extractor where certain valid class bases, including subscript expressions such as `list[int]`, were not parsed correctly.
