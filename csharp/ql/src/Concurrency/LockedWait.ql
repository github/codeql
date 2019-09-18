/**
 * @name A lock is held during a wait
 * @description A lock is held during a call to System.Threading.Monitor.Wait(). This can lead to deadlocks and performance problems.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/locked-wait
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-662
 *       external/cwe/cwe-833
 */

import csharp
import Concurrency

from LockedBlock l, WaitStmt w, string lockedItem
where
  l.getALockedStmt() = w and
  (
    exists(Variable v |
      v = l.getLockVariable() and not v = w.getWaitVariable() and lockedItem = v.getName()
    )
    or
    exists(Type t |
      t = l.getLockTypeObject() and
      not t = w.getWaitTypeObject() and
      lockedItem = "typeof(" + t.getName() + ")"
    )
    or
    l.isLockThis() and not w.isWaitThis() and lockedItem = "this"
  )
select w, "'" + lockedItem + "' is locked during this wait."
