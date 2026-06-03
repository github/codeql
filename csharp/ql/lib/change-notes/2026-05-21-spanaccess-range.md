---
category: minorAnalysis
---
* Improved extraction of range-access expressions on spans and strings (for example, `a[0..3]`). These expressions are now extracted as `Slice` (span) or `Substring` (string) calls.
