---
category: fix
---

- Using `=` as a fill character in a format specifier (e.g `f"{x:=^20}"`) now no longer results in a syntax error during parsing.
