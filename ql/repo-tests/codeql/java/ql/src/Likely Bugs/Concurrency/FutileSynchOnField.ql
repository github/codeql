/**
 * @name Futile synchronization on field
 * @description Synchronizing on a field and updating that field while the lock is held is unlikely
 *              to provide the desired thread safety.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/unsafe-sync-on-field
 * @tags reliability
 *       correctness
 *       concurrency
 *       language-features
 *       external/cwe/cwe-662
 */

import java

private Field synchField(SynchronizedStmt s) { result = s.getExpr().(VarAccess).getVariable() }

private Field assignmentToField(Assignment a) { result = a.getDest().(VarAccess).getVariable() }

from SynchronizedStmt s, Field f, Assignment a
where
  synchField(s) = f and
  assignmentToField(a) = f and
  a.getEnclosingStmt().getEnclosingStmt*() = s
select a, "Synchronization on field $@ in futile attempt to guard that field.", f,
  f.getDeclaringType().getName() + "." + f.getName()
