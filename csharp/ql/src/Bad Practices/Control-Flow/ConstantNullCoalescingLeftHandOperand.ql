/**
 * @name Null-coalescing left operand is constant
 * @description Finds left operands in null-coalescing expressions that always evaluate to null
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/constant-null-coalescing
 * @tags maintainability
 *       readability
 */
import csharp

from NullCoalescingExpr nce, Expr e
where e = nce.getLeftOperand()
  and exists(e.getValue())
select e, "Left operand always evaluates to " + e.getValue() + "."
