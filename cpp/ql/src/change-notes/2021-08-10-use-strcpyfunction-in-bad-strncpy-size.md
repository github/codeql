---
category: minorAnalysis
---
* The query `cpp/bad-strncpy-size` now covers more `strncpy`-like functions than before, including `strxfrm`(`_l`), `wcsxfrm`(`_l`), and `stpncpy`. Users of this query may see an increase in results.
