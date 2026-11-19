---
category: breaking
---
* Updated `Guard.isEquality` to use `GuardValue` instead of `boolean`. To adapt
  to this api change either use `GuardValue.asBooleanValue()`, or preferably, if
  the guard is used in conjunction with `Guard.controls`, switch to use
  `Guard.valueControls`.
