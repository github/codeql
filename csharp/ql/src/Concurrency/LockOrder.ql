/**
 * @name Inconsistent lock sequence
 * @description Locking in an inconsistent sequence can lead to deadlock.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/inconsistent-lock-sequence
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-662
 */

import csharp

LockStmt getAReachableLockStmt(Callable callable) {
  result.getEnclosingCallable() = callable
  or
  exists(Call c | c.getEnclosingCallable() = callable |
    result = getAReachableLockStmt(c.getARuntimeTarget())
  )
}

predicate nestedLocks(LockStmt outer, LockStmt inner) {
  inner = outer.getALockedStmt()
  or
  exists(Call call | call.getEnclosingStmt() = outer.getALockedStmt() |
    inner = getAReachableLockStmt(call.getARuntimeTarget())
  )
}

from LockStmt outer1, LockStmt inner1, LockStmt outer2, LockStmt inner2, Variable v1, Variable v2
where
  nestedLocks(outer1, inner1) and
  nestedLocks(outer2, inner2) and
  outer1.getLockVariable() = v1 and
  inner1.getLockVariable() = v2 and
  outer2.getLockVariable() = v2 and
  inner2.getLockVariable() = v1 and
  v1 != v2 and
  v1.getName() <= v2.getName()
select inner2, "Inconsistent lock sequence. The locks " + v1 + " and " + v2 + " are locked in a different sequence $@.",
  inner1, "here"
