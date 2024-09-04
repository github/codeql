---
category: minorAnalysis
---
* Added a data flow model for `realloc`-like functions, which were previously modeled as a taint tracking functions. This change improves the precision of queries where flow through `realloc`-like functions might affect the results.
