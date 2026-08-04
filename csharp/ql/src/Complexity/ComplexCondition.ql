/**
 * @name Complex condition
 * @description Boolean expressions should not be too deeply nested. Naming intermediate results as local variables will make the logic easier to read and understand.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/complex-condition
 * @tags maintainability
 *       readability
 *       testability
 */

import csharp

abstract class RelevantBinaryOperations extends Operation { }

private class AddBinaryLogicalOperationRelevantBinaryOperations extends RelevantBinaryOperations,
  BinaryLogicalOperation
{ }

private class AddAssignCoalesceExprRelevantBinaryOperations extends RelevantBinaryOperations,
  AssignCoalesceExpr
{ }

abstract class RelevantOperations extends Operation { }

private class AddLogicalOperationRelevantOperations extends RelevantOperations, LogicalOperation { }

private class AddAssignCoalesceExprRelevantOperations extends RelevantOperations, AssignCoalesceExpr
{ }

predicate nontrivialLogicalOperator(RelevantBinaryOperations e) {
  not exists(RelevantBinaryOperations parent |
    parent = e.getParent() and
    parent.getOperator() = e.getOperator()
  )
}

predicate logicalParent(RelevantOperations op, RelevantOperations parent) {
  parent = op.getParent()
}

from Expr e, int operators
where
  not e.getParent() instanceof RelevantOperations and
  operators =
    count(RelevantBinaryOperations op | logicalParent*(op, e) and nontrivialLogicalOperator(op)) and
  operators > 3
select e, "Complex condition: too many logical operations in this expression."
