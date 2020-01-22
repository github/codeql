/**
 * @name Complex condition
 * @description Boolean expressions should not be too deeply nested. Naming intermediate results as local variables will make the logic easier to read and understand.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/complex-condition
 * @tags testability
 *       readability
 */

import csharp

predicate nontrivialLogicalOperator(BinaryLogicalOperation e) {
  not exists(BinaryLogicalOperation parent |
    parent = e.getParent() and
    parent.getOperator() = e.getOperator()
  )
}

predicate logicalParent(LogicalOperation op, LogicalOperation parent) { parent = op.getParent() }

from Expr e, int operators
where
  not e.getParent() instanceof LogicalOperation and
  operators =
    count(BinaryLogicalOperation op | logicalParent*(op, e) and nontrivialLogicalOperator(op)) and
  operators > 3
select e.getLocation(), "Complex condition: too many logical operations in this expression."
