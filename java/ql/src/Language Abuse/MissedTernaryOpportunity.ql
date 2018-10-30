/**
 * @name Missed ternary opportunity
 * @description An 'if' statement where both branches either
 *             (a) return or (b) write to the same variable
 *             can often be expressed more clearly using the '?' operator.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/missed-ternary-operator
 * @tags maintainability
 *       language-features
 */

import java

predicate complicatedBranch(Stmt branch) {
  exists(ConditionalExpr ce | ce.getParent*() = branch) or
  count(MethodAccess a | a.getParent*() = branch) > 1
}

predicate complicatedCondition(Expr cond) {
  exists(Expr e | e = cond.getAChildExpr*() |
    e instanceof AndLogicalExpr or
    e instanceof OrLogicalExpr
  )
}

predicate toCompare(Expr left, Expr right) {
  exists(IfStmt is, AssignExpr at, AssignExpr ae |
    at.getParent() = is.getThen() and
    ae.getParent() = is.getElse()
  |
    left = at.getDest() and right = ae.getDest()
    or
    left = at.getDest().(VarAccess).getQualifier() and
    right = ae.getDest().(VarAccess).getQualifier()
  )
}

predicate sameVariable(VarAccess left, VarAccess right) {
  toCompare(left, right) and
  left.getVariable() = right.getVariable() and
  (
    exists(Expr q1, Expr q2 |
      left.getQualifier() = q1 and
      sameVariable(q1, q2) and
      right.getQualifier() = q2
    )
    or
    left.isLocal() and right.isLocal()
  )
}

from IfStmt is, string what
where
  (
    is.getThen() instanceof ReturnStmt and
    is.getElse() instanceof ReturnStmt and
    what = "return"
    or
    exists(AssignExpr at, AssignExpr ae |
      at.getParent() = is.getThen() and
      ae.getParent() = is.getElse() and
      sameVariable(at.getDest(), ae.getDest()) and
      what = "write to the same variable"
    )
  ) and
  // Exclusions.
  not (
    exists(IfStmt other | is = other.getElse()) or
    complicatedCondition(is.getCondition()) or
    complicatedBranch(is.getThen()) or
    complicatedBranch(is.getElse())
  )
select is,
  "Both branches of this 'if' statement " + what + " - consider using '?' to express intent better."
