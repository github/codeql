---
category: minorAnalysis
---
* Fixed a bug that would occur when an `initialize` method returns `self` or one of its parameters.
  In such cases, the corresponding calls to `new` would be associated with an incorrect return type.
  This could result in inaccurate call target resolution and cause false positive alerts.
