---
category: minorAnalysis
---
* Removed the summary model for `String.valueOf(CharSequence)`, which does not exist. Instead, taint is now propagated through calls to `String.valueOf(Object)` when the argument is a `CharSequence`, for example a `String` or a `StringBuilder`.
