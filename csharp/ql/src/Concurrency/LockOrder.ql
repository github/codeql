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

from LockStmt l1, LockStmt l2, LockStmt l3, LockStmt l4, Variable v1, Variable v2
where l1.getALockedStmt()=l2
and l3.getALockedStmt()=l4
and l1.getLockVariable()=v1
and l2.getLockVariable()=v2
and l3.getLockVariable()=v2
and l4.getLockVariable()=v1
and v1!=v2
select l4, "Inconsistent lock sequence. The locks " + v1 + " and " + v2 + " are locked in a different sequence $@.",
  l2, "here"
