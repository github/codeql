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

private Expr getAssignedExpr(Stmt stmt) {
  result = stmt.stripSingletonBlocks().(ExprStmt).getExpr().(AssignExpr).getLValue()
}

from IfStmt is, string what
where
  (
    is.getThen().stripSingletonBlocks() instanceof ReturnStmt and
    is.getElse().stripSingletonBlocks() instanceof ReturnStmt and
    what = "return"
    or
    sameGvn(getAssignedExpr(is.getThen()), getAssignedExpr(is.getElse())) and
    what = "write to the same variable"
  ) and
  not exists(IfStmt other | is = other.getElse())
select is,
  "Both branches of this 'if' statement " + what + " - consider using '?' to express intent better."
