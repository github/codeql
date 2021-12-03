/**
 * @name Unread local variable
 * @description A local variable that is never read is redundant.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/local-variable-is-never-read
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java

VarAccess getARead(LocalVariableDecl v) {
  v.getAnAccess() = result and
  not exists(Assignment assign | assign.getDest() = result)
}

predicate readImplicitly(LocalVariableDecl v) {
  exists(TryStmt t | t.getAResourceDecl().getAVariable() = v.getDeclExpr())
}

from LocalVariableDecl v
where
  not exists(getARead(v)) and
  // Discarded exceptions are covered by another query.
  not exists(CatchClause cc | cc.getVariable().getVariable() = v) and
  not readImplicitly(v)
select v, "Variable '" + v + "' is never read."
