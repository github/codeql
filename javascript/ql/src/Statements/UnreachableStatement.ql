/**
 * @name Unreachable statement
 * @description Unreachable statements are often indicative of missing code or latent bugs and should be avoided.
 * @kind problem
 * @problem.severity warning
 * @id js/unreachable-statement
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

from Stmt s
where
  // `s` is unreachable in the CFG
  s.getFirstControlFlowNode().isUnreachable() and
  // the CFG does not model all possible exceptional control flow, so be conservative about catch clauses
  not s instanceof CatchClause and
  // function declarations are special and always reachable
  not s instanceof FunctionDeclStmt and
  // allow a spurious 'break' statement at the end of a switch-case
  not exists(Case c, int i | i = c.getNumBodyStmt() | s.(BreakStmt) = c.getBodyStmt(i - 1)) and
  // ignore ambient statements
  not s.isAmbient() and
  // ignore empty statements
  not s instanceof EmptyStmt and
  // ignore unreachable throws
  not s instanceof ThrowStmt
select s.(FirstLineOf), "This statement is unreachable."
