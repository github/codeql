---
category: minorAnalysis
---
* Fixed false positives from the `rust/access-invalid-pointer` query, by only considering dereferences of raw pointers as sinks.
