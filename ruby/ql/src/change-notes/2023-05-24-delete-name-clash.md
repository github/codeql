---
category: minorAnalysis
---
* Fixed an issue where calls to `delete` or `assoc` with a constant-valued argument would be analyzed imprecisely,
  as if the argument value was not a known constant.
