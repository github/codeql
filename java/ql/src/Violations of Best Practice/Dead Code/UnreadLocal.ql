/**
 * @name Unread local variable
 * @description A local variable that is never read is redundant.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/local-variable-is-never-read
 * @suites security-and-quality
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
  // Exclude common Kotlin pattern to do something n times: `for(i in 1..n) { doSomething() }
  not exists(EnhancedForStmt f |
    f.getVariable().getVariable() = v and
    f.getExpr().getType().(RefType).hasQualifiedName("kotlin.ranges", ["IntRange", "LongRange"])
  ) and
  not readImplicitly(v)
select v, "Variable '" + v + "' is never read."
