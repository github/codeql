---
category: minorAnalysis
---
* Fixed a bug in how `map_filter` calls are analyzed. Previously, such calls would
  appear to the return the receiver of the call, but now the return value of the callback
  is properly taken into account.
