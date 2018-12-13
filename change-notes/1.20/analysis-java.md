# Improvements to Java analysis

## General improvements


## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Double-checked locking is not thread-safe (`java/unsafe-double-checked-locking`) | reliability, correctness, concurrency, external/cwe/cwe-609 | Identifies wrong implementations of double-checked locking that does not use the `volatile` keyword. |
| Race condition in double-checked locking object initialization (`java/unsafe-double-checked-locking-init-order`) | reliability, correctness, concurrency, external/cwe/cwe-609 | Identifies wrong implementations of double-checked locking that performs additional initialization after exposing the constructed object. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|

## Changes to QL libraries

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


