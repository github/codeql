---
category: minorAnalysis
---
* The `Class::hasImplicitCopyConstructor` and `Class::hasImplicitCopyAssignmentOperator` methods now handle template instantiations more accurately. This should improve results for the `cpp/rule-of-two` query.