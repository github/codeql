/**
 * @name Useless ?? expression
 * @description The null-coalescing operator is intended to help provide special handling for the case when a variable is null - its two operands should
 *              always do different things.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/coalesce-of-identical-expressions
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import csharp
import semmle.code.csharp.commons.StructuralComparison

private predicate uselessNullCoalescingExpr(NullCoalescingExpr nce) {
  forex(AssignableAccess y |
    y = nce.getRightOperand().getAChildExpr*() and sameGvn(nce.getLeftOperand(), y)
  |
    y instanceof AssignableRead and not y.isRefArgument()
  )
}

from NullCoalescingExpr nce
where uselessNullCoalescingExpr(nce)
select nce, "Both operands of this null-coalescing expression access the same variable or property."
