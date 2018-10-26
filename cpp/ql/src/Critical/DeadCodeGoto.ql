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

Stmt getNextRealStmt(Block b, int i) {
  result = b.getStmt(i + 1) and
  not result instanceof EmptyStmt
  or
  b.getStmt(i + 1) instanceof EmptyStmt and
  result = getNextRealStmt(b, i + 1)
}

from JumpStmt js, Block b, int i, Stmt s
where b.getStmt(i) = js
  and s = getNextRealStmt(b, i)
  // the next statement isn't jumped to
  and not s instanceof LabelStmt
  and not s instanceof SwitchCase
  // the next statement isn't breaking out of a switch
  and not s.(BreakStmt).getBreakable() instanceof SwitchStmt
  // the next statement isn't a loop that can be jumped into
  and not exists (LabelStmt ls | s.(Loop).getStmt().getAChild*() = ls)
  and not exists (SwitchCase sc | s.(Loop).getStmt().getAChild*() = sc)
select js, "This statement makes $@ unreachable.", s, s.toString()
