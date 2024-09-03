---
category: minorAnalysis
---
* Added a data-flow model for `realloc` and related functions. Previously they was modeled as a taint functions. This improves the precision of queries using data-flow or taint-tracking when `realloc` is involved.
