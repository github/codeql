/**
 * @name Complex condition
 * @description Boolean expressions that are too deeply nested are hard to read and understand. Consider naming intermediate results as local variables.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/complex-condition
 * @tags testability
 *       readability
 *       maintainability
 *       statistical
 *       non-attributable
 */

import cpp

predicate logicalOp(string op) { op = "&&" or op = "||" }

predicate nontrivialLogicalOperator(Operation e) {
  exists(string op |
    op = e.getOperator() and
    logicalOp(op) and
    not op = e.getParent().(Operation).getOperator()
  ) and
  not e.isInMacroExpansion()
}

from Expr e, int operators
where
  not e.getParent() instanceof Expr and
  operators = count(Operation op | op.getParent*() = e and nontrivialLogicalOperator(op)) and
  operators > 5
select e, "Complex condition: too many logical operations in this expression."
