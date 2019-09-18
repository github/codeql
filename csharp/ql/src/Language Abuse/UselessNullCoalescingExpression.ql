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

class StructuralComparisonConfig extends StructuralComparisonConfiguration {
  StructuralComparisonConfig() { this = "UselessNullCoalescingExpression" }

  override predicate candidate(ControlFlowElement x, ControlFlowElement y) {
    exists(NullCoalescingExpr nce |
      x.(Access) = nce.getLeftOperand() and
      y.(Access) = nce.getRightOperand().getAChildExpr*()
    )
  }

  NullCoalescingExpr getUselessNullCoalescingExpr() {
    exists(AssignableAccess x |
      result.getLeftOperand() = x and
      forex(AssignableAccess y | same(x, y) | y instanceof AssignableRead and not y.isRefArgument())
    )
  }
}

from StructuralComparisonConfig c, NullCoalescingExpr nce
where nce = c.getUselessNullCoalescingExpr()
select nce, "Both operands of this null-coalescing expression access the same variable or property."
