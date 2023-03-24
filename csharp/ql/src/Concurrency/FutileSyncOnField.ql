/**
 * @name Futile synchronization on field
 * @description Synchronizing on a field and updating that field while the lock is held is unlikely
 *              to provide the desired thread safety.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/unsafe-sync-on-field
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-662
 *       external/cwe/cwe-366
 */

import csharp

predicate lockedFieldUpdate(LockStmt lock, Field f, AssignableDefinition def) {
  lock.getAChild+() = def.getAControlFlowNode().getElement() and
  def.getTarget() = f
}

from LockStmt lock, Expr e, Field f, AssignableDefinition def
where
  e = lock.getExpr() and
  f.getAnAccess() = e and
  lockedFieldUpdate(lock, f, def)
select e,
  "Locking field $@ guards the initial value, not the value which may be seen from another thread after $@.",
  f, f.getName(), def, "reassignment"
