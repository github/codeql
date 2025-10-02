---
category: breaking
---
* The member predicate `writesField` on `DataFlow::Write` now uses the post-update node for `base` when that is the node being updated, which is in all cases except initializing a struct literal. A new member predicate `writesFieldPreUpdate` has been added for cases where this behaviour is not desired.
* The member predicate `writesElement` on `DataFlow::Write` now uses the post-update node for `base` when that is the node being updated, which is in all cases except initializing an array/slice/map literal. A new member predicate `writesElementPreUpdate` has been added for cases where this behaviour is not desired.
