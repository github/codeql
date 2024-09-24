---
category: minorAnalysis
---
* The common sanitizer guard `StringConstCompareBarrier` has been renamed to `ConstCompareBarrier` and expanded to cover comparisons with other constant values such as `None`. This may result in fewer false positive results for several queries. 