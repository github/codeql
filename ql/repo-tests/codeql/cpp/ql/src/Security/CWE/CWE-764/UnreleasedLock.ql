/**
 * @name Lock may not be released
 * @description A lock that is acquired one or more times without a
 *              matching number of unlocks may cause a deadlock.
 * @kind problem
 * @id cpp/unreleased-lock
 * @problem.severity error
 * @security-severity 5.0
 * @precision low
 * @tags security
 *       external/cwe/cwe-764
 *       external/cwe/cwe-833
 */

import cpp
import semmle.code.cpp.commons.Synchronization

predicate lockBlock(MutexType t, BasicBlock b, int locks) {
  locks = strictcount(int i | b.getNode(i) = t.getLockAccess())
}

predicate unlockBlock(MutexType t, BasicBlock b, int unlocks) {
  unlocks = strictcount(int i | b.getNode(i) = t.getUnlockAccess())
}

/**
 * Holds if there is a call to `lock` or `tryLock` on `t` in
 * `lockblock`, and `failblock` is the successor if it fails.
 */
predicate failedLock(MutexType t, BasicBlock lockblock, BasicBlock failblock) {
  exists(ControlFlowNode lock |
    lock = lockblock.getEnd() and
    lock = t.getLockAccess() and
    lock.getAFalseSuccessor() = failblock
  )
}

/**
 * Holds if `b` locks `t` a net `netlocks` times. For example, if `b`
 * locks `t` twice and unlocks `t` four times, then `netlocks` will be
 * `-2`.
 */
predicate lockUnlockBlock(MutexType t, BasicBlock b, int netlocks) {
  lockBlock(t, b, netlocks) and not unlockBlock(t, b, _)
  or
  exists(int unlocks |
    not lockBlock(t, b, _) and unlockBlock(t, b, unlocks) and netlocks = -unlocks
  )
  or
  exists(int locks, int unlocks |
    lockBlock(t, b, locks) and unlockBlock(t, b, unlocks) and netlocks = locks - unlocks
  )
}

/**
 * Holds if there is a control flow path from `src` to `b` such that
 * on that path the net number of locks is `locks`, and `locks` is
 * positive.
 */
predicate blockIsLocked(MutexType t, BasicBlock src, BasicBlock b, int locks) {
  lockUnlockBlock(t, b, locks) and src = b and locks > 0
  or
  exists(BasicBlock pred, int predlocks, int curlocks, int failedlock | pred = b.getAPredecessor() |
    blockIsLocked(t, src, pred, predlocks) and
    (if failedLock(t, pred, b) then failedlock = 1 else failedlock = 0) and // count a failed lock as an unlock so the net is zero
    (
      not lockUnlockBlock(t, b, _) and curlocks = 0
      or
      lockUnlockBlock(t, b, curlocks)
    ) and
    locks = predlocks + curlocks - failedlock and
    locks > 0 and
    locks < 10 // arbitrary bound to fail gracefully in case of locking in a loop
  )
}

from Function c, MutexType t, BasicBlock src, BasicBlock exit, FunctionCall lock
where
  // restrict results to those methods that actually attempt to unlock
  t.getUnlockAccess().getEnclosingFunction() = c and
  blockIsLocked(t, src, exit, _) and
  exit.getEnd() = c and
  lock = src.getANode() and
  lock = t.getLockAccess()
select lock, "This lock might not be unlocked or might be locked more times than it is unlocked."
