---
category: feature
---
* The `StateConfigSig` signature now supports a unary `isSink` predicate that does not specify the `FlowState` for which the given node is a sink. Instead, any `FlowState` is considered a valid `FlowState` for such a sink.