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

private predicate candidate(AsExpr ae, IsExpr ie) {
  exists(IfStmt is, TypeAccessPatternExpr tape |
    ie = is.getCondition().getAChild*() and
    tape = ie.getPattern() and
    ae.getTargetType() = tape.getTarget()
  |
    ae = is.getThen().getAChild*()
    or
    ae = is.getElse().getAChild*()
  )
}

private predicate uselessIsBeforeAs(AsExpr ae, IsExpr ie) {
  candidate(ae, ie) and
  sameGvn(ie.getExpr(), ae.getExpr())
}

from AsExpr ae, IsExpr ie
where
  uselessIsBeforeAs(ae, ie) and
  not exists(MethodCall mc | ae = mc.getAnArgument().getAChildExpr*())
select ae,
  "This 'as' expression performs a type test - it should be directly compared against null, rendering the 'is' $@ potentially redundant.",
  ie, "here"
