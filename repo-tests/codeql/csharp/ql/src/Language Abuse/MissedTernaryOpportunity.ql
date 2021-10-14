/**
 * @name Missed ternary opportunity
 * @description An 'if' statement where both branches either (a) return or (b) write to the same variable can often be expressed more clearly using the '?' operator.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/missed-ternary-operator
 * @tags maintainability
 *       language-features
 */

import csharp
import semmle.code.csharp.commons.StructuralComparison

class StructuralComparisonConfig extends StructuralComparisonConfiguration {
  StructuralComparisonConfig() { this = "MissedTernaryOpportunity" }

  override predicate candidate(ControlFlowElement x, ControlFlowElement y) {
    exists(IfStmt is, AssignExpr ae1 |
      ae1 = is.getThen().stripSingletonBlocks().(ExprStmt).getExpr()
    |
      x = ae1.getLValue() and
      exists(AssignExpr ae2 | ae2 = is.getElse().stripSingletonBlocks().(ExprStmt).getExpr() |
        y = ae2.getLValue()
      )
    )
  }

  IfStmt getIfStmt() {
    exists(AssignExpr ae | ae = result.getThen().stripSingletonBlocks().(ExprStmt).getExpr() |
      same(ae.getLValue(), _)
    )
  }
}

from IfStmt is, string what
where
  (
    is.getThen().stripSingletonBlocks() instanceof ReturnStmt and
    is.getElse().stripSingletonBlocks() instanceof ReturnStmt and
    what = "return"
    or
    exists(StructuralComparisonConfig c |
      is = c.getIfStmt() and
      what = "write to the same variable"
    )
  ) and
  not exists(IfStmt other | is = other.getElse())
select is,
  "Both branches of this 'if' statement " + what + " - consider using '?' to express intent better."
