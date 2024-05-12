## 0.8.0

### New Features

* The `ProductFlow::StateConfigSig` signature now includes default predicates for `isBarrier1`, `isBarrier2`, `isAdditionalFlowStep1`, and `isAdditionalFlowStep1`. Hence, it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Deleted the deprecated `getURL` predicate from the `Container`, `Folder`, and `File` classes. Use the `getLocation` predicate instead.
