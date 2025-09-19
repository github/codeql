---
category: breaking
---
* The member predicate `writesField(DataFlow::Node base, Field f, DataFlow::Node rhs)` on `DataFlow::Write` now uses the post-update node for `base` when that is the node being updated, which is in all cases except initializing a struct literal. A new member predicate `writesFieldOnSsaWithFields(SsaWithFields v, Field f, DataFlow::Node rhs)` has been added for the case of writes to a SsaWithFields node.
* The member predicate `writesElement(DataFlow::Node base, DataFlow::Node index, DataFlow::Node rhs)` on `DataFlow::Write` now uses the post-update node for `base` when that is the node being updated, which is in all cases except initializing an array/slice/map literal.
* The member predicate `writesComponent(DataFlow::Node base, DataFlow::Node rhs)` on `DataFlow::Write` now uses the post-update node for `base` when that is the node being updated, which is in all cases except initializing a struct/array/slice/map literal.
