---
category: deprecated
---
* The `AstNode.getAFlowNode()` predicate has been deprecated. Use `ControlFlowNode.getNode()` from the other direction instead: replace `e.getAFlowNode() = n` with `n.getNode() = e`. This is a preparatory step towards migrating the dataflow library off the legacy CFG; it has no semantic effect.

