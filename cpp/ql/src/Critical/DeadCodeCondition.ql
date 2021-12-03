/**
 * @name Branching condition always evaluates to same value
 * @description The condition of the branching statement always evaluates to the same value. This means that only one branch will ever be executed.
 * @kind problem
 * @id cpp/dead-code-condition
 * @problem.severity warning
 * @tags reliability
 *       external/cwe/cwe-561
 */

import cpp

predicate testAndBranch(Expr e, Stmt branch) {
  exists(IfStmt ifstmt |
    ifstmt.getCondition() = e and
    (ifstmt.getThen() = branch or ifstmt.getElse() = branch)
  )
  or
  exists(WhileStmt while |
    while.getCondition() = e and
    while.getStmt() = branch
  )
}

predicate choice(StackVariable v, Stmt branch, string value) {
  exists(AnalysedExpr e |
    testAndBranch(e, branch) and
    (
      e.getNullSuccessor(v) = branch and value = "null"
      or
      e.getNonNullSuccessor(v) = branch and value = "non-null"
    )
  )
}

predicate guarded(StackVariable v, Stmt loopstart, AnalysedExpr child) {
  choice(v, loopstart, _) and
  loopstart.getChildStmt*() = child.getEnclosingStmt() and
  (definition(v, child) or exists(child.getNullSuccessor(v)))
}

predicate addressLeak(Variable v, Stmt leak) {
  exists(VariableAccess access |
    v.getAnAccess() = access and
    access.getEnclosingStmt() = leak and
    access.isAddressOfAccess()
  )
}

from StackVariable v, Stmt branch, AnalysedExpr cond, string context, string test, string testresult
where
  choice(v, branch, context) and
  forall(ControlFlowNode def | definition(v, def) and definitionReaches(def, cond) |
    not guarded(v, branch, def)
  ) and
  not cond.isDef(v) and
  guarded(v, branch, cond) and
  exists(cond.getNullSuccessor(v)) and
  not addressLeak(v, branch.getChildStmt*()) and
  (
    cond.isNullCheck(v) and test = "null"
    or
    cond.isValidCheck(v) and test = "non-null"
  ) and
  (if context = test then testresult = "succeed" else testresult = "fail")
select cond,
  "Variable '" + v.getName() + "' is always " + context + " here, this check will always " +
    testresult + "."
