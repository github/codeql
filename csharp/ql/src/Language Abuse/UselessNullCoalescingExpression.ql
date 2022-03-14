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

pragma[noinline]
private predicate same(AssignableAccess x, AssignableAccess y) {
  exists(NullCoalescingExpr nce |
    x = nce.getLeftOperand() and
    y = nce.getRightOperand().getAChildExpr*()
  ) and
  sameGvn(x, y)
}

private predicate uselessNullCoalescingExpr(NullCoalescingExpr nce) {
  exists(AssignableAccess x |
    nce.getLeftOperand() = x and
    forex(AssignableAccess y | same(x, y) | y instanceof AssignableRead and not y.isRefArgument())
  )
}

from NullCoalescingExpr nce
where uselessNullCoalescingExpr(nce)
select nce, "Both operands of this null-coalescing expression access the same variable or property."
