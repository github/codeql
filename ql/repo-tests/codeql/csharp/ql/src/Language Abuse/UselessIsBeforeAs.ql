/**
 * @name Useless 'is' before 'as'
 * @description The C# 'as' operator performs a type test - there is no need to precede it with an 'is'.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/useless-is-before-as
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import csharp
import semmle.code.csharp.commons.StructuralComparison

class StructuralComparisonConfig extends StructuralComparisonConfiguration {
  StructuralComparisonConfig() { this = "UselessIsBeforeAs" }

  override predicate candidate(ControlFlowElement x, ControlFlowElement y) {
    exists(IfStmt is, AsExpr ae, IsExpr ie, TypeAccessPatternExpr tape |
      ie = is.getCondition().getAChild*() and
      tape = ie.getPattern() and
      ae.getTargetType() = tape.getTarget() and
      x = ie.getExpr() and
      y = ae.getExpr()
    |
      ae = is.getThen().getAChild*()
      or
      ae = is.getElse().getAChild*()
    )
  }

  predicate uselessIsBeforeAs(AsExpr ae, IsExpr ie) {
    exists(Expr x, Expr y |
      same(x, y) and
      ie.getExpr() = x and
      ae.getExpr() = y
    )
  }
}

from AsExpr ae, IsExpr ie
where
  exists(StructuralComparisonConfig c | c.uselessIsBeforeAs(ae, ie)) and
  not exists(MethodCall mc | ae = mc.getAnArgument().getAChildExpr*())
select ae,
  "This 'as' expression performs a type test - it should be directly compared against null, rendering the 'is' $@ potentially redundant.",
  ie, "here"
