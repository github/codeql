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

/**
 * Gets a call target conservatively only when there is
 * one runtime target.
 */
Callable getCallTarget(Call c) {
  count(c.getARuntimeTarget()) = 1 and
  result = c.getARuntimeTarget()
}

/** Gets a lock statement reachable from a callable. */
LockStmt getAReachableLockStmt(Callable callable) {
  result.getEnclosingCallable() = callable
  or
  exists(Call call | call.getEnclosingCallable() = callable |
    result = getAReachableLockStmt(getCallTarget(call))
  )
}

/**
 * Holds if there is nested pairs of lock statements, either
 * inter-procedurally or intra-procedurally.
 */
predicate nestedLocks(Variable outerVariable, Variable innerVariable, LockStmt outer, LockStmt inner) {
  outerVariable = outer.getLockVariable() and
  innerVariable = inner.getLockVariable() and
  outerVariable != innerVariable and
  (
    inner = outer.getALockedStmt()
    or
    exists(Call call | call.getEnclosingStmt() = outer.getALockedStmt() |
      inner = getAReachableLockStmt(getCallTarget(call))
    ) and
    outerVariable.(Modifiable).isStatic() and
    innerVariable.(Modifiable).isStatic()
  )
}

from LockStmt outer1, LockStmt inner1, LockStmt outer2, LockStmt inner2, Variable v1, Variable v2
where
  nestedLocks(v1, v2, outer1, inner1) and
  nestedLocks(v2, v1, outer2, inner2) and
  v1.getName() <= v2.getName()
select v1, "Inconsistent lock sequence with $@. Lock sequences $@, $@ and $@, $@ found.", v2,
  v2.getName(), outer1, v1.getName(), inner1, v2.getName(), outer2, v2.getName(), inner2,
  v1.getName()
