/**
 * @name Cyclic lock order dependency
 * @description Locking mutexes in different orders in different
 *              threads can cause deadlock.
 * @kind problem
 * @id cpp/lock-order-cycle
 * @problem.severity error
 * @tags security
 *       external/cwe/cwe-764
 *       external/cwe/cwe-833
 */

import cpp
import semmle.code.cpp.commons.Synchronization
import LockFlow

/**
 * Gets a variable that might be locked while a lock on `v` is held.
 *
 * For example, with
 * ```
 * x.lock()
 * y.lock()
 * x.unlock()
 * y.unlock()
 *```
 * `x` is already locked when `y.lock()` is called, so `y` is a result
 * of `lockSuccessor(x)`. If you consider this an edge from `x` to `y`
 * in a directed graph, then a cycle in the graph indicates a potential
 * source of deadlock. The dining philosophers are the classic example.
 */
Variable lockSuccessor(Variable v) {
  exists(FunctionCall call |
    lockedOnEntry(v.getAnAccess(), call) and
    lockedInCall(result.getAnAccess(), call)
  )
}

from Variable v1, Variable v2
where v1 != v2 and lockSuccessor+(v1) = v2 and lockSuccessor+(v2) = v1
select v1, "Mutex " + v1 + " has a cyclic lock order dependency with $@.", v2, "mutex " + v2
