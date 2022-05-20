/**
 * @name Dead code due to goto or break statement
 * @description A goto or break statement is followed by unreachable code.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/dead-code-goto
 * @tags maintainability
 *       external/cwe/cwe-561
 */

import cpp
import semmle.code.cpp.commons.Exclusions

Stmt getNextRealStmt(BlockStmt b, int i) {
  result = b.getStmt(i + 1) and
  not result instanceof EmptyStmt
  or
  b.getStmt(i + 1) instanceof EmptyStmt and
  result = getNextRealStmt(b, i + 1)
}

from JumpStmt js, BlockStmt b, int i, Stmt s
where
  b.getStmt(i) = js and
  s = getNextRealStmt(b, i) and
  // the next statement isn't jumped to
  not s instanceof LabelStmt and
  not s instanceof SwitchCase and
  // the next statement isn't breaking out of a switch
  not s.(BreakStmt).getBreakable() instanceof SwitchStmt and
  // the next statement isn't a loop that can be jumped into
  not s.(Loop).getStmt().getAChild*() instanceof LabelStmt and
  not s.(Loop).getStmt().getAChild*() instanceof SwitchCase and
  // no preprocessor logic applies
  not functionContainsPreprocCode(js.getEnclosingFunction())
select js, "This statement makes $@ unreachable.", s, s.toString()
