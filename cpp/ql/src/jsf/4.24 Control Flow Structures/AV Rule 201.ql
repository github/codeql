/**
 * @name For loop variable changed in body
 * @description Numeric variables being used within a for loop for iteration counting should not be modified in the body of the loop. Reserve for loops for straightforward iterations, and use a while loop instead for more complex cases.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/loop-variable-changed
 * @tags reliability
 *       readability
 *       external/jsf
 */

import cpp
import Likely_Bugs.NestedLoopSameVar

pragma[noopt]
predicate loopModification(ForStmt for, Variable loopVariable, VariableAccess acc) {
  loopVariable = for.getAnIterationVariable() and
  acc = loopVariable.getAnAccess() and
  acc.isModified() and
  exists(Stmt stmt | acc.getEnclosingStmt() = stmt and stmtInForBody(stmt, for))
}

pragma[noopt]
predicate stmtInForBody(Stmt stmt, ForStmt forStmt) {
  (
    forStmt.getStmt() = stmt
    or
    exists(StmtParent parent | parent = stmt.getParent() | stmtInForBody(parent, forStmt))
  ) and
  forStmt instanceof ForStmt
}

from ForStmt for, Variable loopVariable, VariableAccess acc
where
  loopModification(for, loopVariable, acc) and
  // field accesses must have the same object
  (
    loopVariable instanceof Field
    implies
    exists(Variable obj |
      simpleFieldAccess(obj, loopVariable, acc) and
      simpleFieldAccess(obj, loopVariable, for.getCondition().getAChild*())
    )
  ) and
  // don't duplicate results from NestedLoopSameVar.ql
  not exists(ForStmt inner |
    nestedForViolation(inner, loopVariable, for) and
    (
      acc.getParent*() = inner or
      acc.getParent*() = inner.getInitialization()
    )
  )
select acc, "Loop counters should not be modified in the body of the $@.", for.getStmt(), "loop"
