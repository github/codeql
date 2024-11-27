---
category: minorAnalysis
---
* Calling `coll.contains(x)` is now a taint sanitizer (for any query) for the value `x`, where `coll` is a collection of constants.
