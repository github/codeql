---
category: feature
---
* The `ProductFlow::StateConfigSig` signature now includes default predicates for `isBarrier1`, `isBarrier2`, `isAdditionalFlowStep1`, and `isAdditionalFlowStep1`. Hence, it is no longer needed to provide `none()` implementations of these predicates if they are not needed.
