/**
 * @name Mutex locked twice
 * @description Calling the lock method of a mutex twice in succession
 *              might cause a deadlock.
 * @kind problem
 * @id cpp/twice-locked
 * @problem.severity error
 * @security-severity 5.0
 * @precision low
 * @tags security
 *       external/cwe/cwe-764
 *       external/cwe/cwe-833
 */

import cpp
import semmle.code.cpp.commons.Synchronization
import LockFlow

/**
 * Holds if `call` locks `v`, via the access `a`, but `v` might already
 * be locked when we reach `call`. The access `a` might be in a function
 * which is called indirectly from `call`.
 */
cached
private predicate twiceLocked(FunctionCall call, Variable v, VariableAccess a) {
  lockedOnEntry(v.getAnAccess(), call) and
  lockedInCall(a, call)
}

// When this query finds a result, there are often multiple call sites
// associated with one instance of the problem. For this reason, we do not
// include `call` in the result. However, it is sometimes helpful to
// include `call.getLocation()` in the result, because it can help to find
// the control flow path which might be responsible.
from FunctionCall call, Variable v, VariableAccess access2
where
  twiceLocked(call, v, access2) and
  v = access2.getTarget() and
  // If the second lock is a `try_lock` then it won't cause a deadlock.
  // We want to be extra sure that the second lock is not a `try_lock`
  // to make sure that we don't generate too many false positives, so
  // we use three heuristics:
  //
  //  1. The call is to a function named "try_lock".
  //  2. The result of the call is used in a condition. For example:
  //       if (pthread_mutex_lock(mtx) != 0) return -1;
  //  3. The call is a condition. Because the analysis is interprocedural,
  //     `call` might be an indirect call to `lock`, so this heuristic
  //     catches some cases which the second heuristic does not.
  not (
    trylockCall(access2, _) or
    tryLockCondition(access2, _, _) or
    call.isCondition()
  )
select access2, "Mutex " + v + " might be locked already, which could cause a deadlock."
