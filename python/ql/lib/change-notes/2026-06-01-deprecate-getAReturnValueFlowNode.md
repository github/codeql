---
category: deprecated
---
* The `Function.getAReturnValueFlowNode()` predicate has been deprecated. Bind a `Return` node explicitly instead — `exists(Return ret | ret.getScope() = f and n.getNode() = ret.getValue())`. This is a preparatory step towards migrating the dataflow library off the legacy CFG; it has no semantic effect.
