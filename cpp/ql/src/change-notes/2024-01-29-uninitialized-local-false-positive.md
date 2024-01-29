---
category: minorAnalysis
---
* Corrected a false positive with `cpp/uninitialized-local`: `a->func()` is a false positive if `func` is static regardless of if `a` is initializeed.