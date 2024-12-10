---
category: breaking
---
* The class `ControlFlowNode` (and by extension `BasicBlock`) is no longer
  directly equatable to `Expr` and `Stmt`. Any queries that have been
  exploiting these equalities, for example by using casts, will need minor
  updates in order to fix any compilation errors. Conversions can be inserted
  in either direction depending on what is most convenient. Available
  conversions include `Expr.getControlFlowNode()`, `Stmt.getControlFlowNode()`,
  `ControlFlowNode.asExpr()`, `ControlFlowNode.asStmt()`, and
  `ControlFlowNode.asCall()`. Exit nodes were until now modelled as a
  `ControlFlowNode` equal to its enclosing `Callable`; these are now instead
  modelled by the class `ControlFlow::ExitNode`.
