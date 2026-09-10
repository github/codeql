---
category: breaking
---
* The deprecated `AstNode.getAFlowNode()` and `Function.getAReturnValueFlowNode()` predicates now return nodes from the new shared CFG (`Cfg::ControlFlowNode`) rather than from the legacy CFG (`ControlFlowNode`). Callers that still rely on these deprecated APIs and feed the result into legacy-CFG-aware predicates will no longer type-check; migrate to `n.getNode() = e` (or, for return values, the explicit `Return` pattern shown in the deprecation message) to get nodes from the dataflow library's current CFG.
