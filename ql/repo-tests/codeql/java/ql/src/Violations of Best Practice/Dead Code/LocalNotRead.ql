/**
 * @name Local variable is never read
 * @description A local variable is written to, but never read. Either the local variable is useless, or its value was intended to be used but is not.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/assigned-local-unread
 */

import java
import DeadLocals

from LocalScopeVariable v
where
  assigned(v) and // Only assignments, not initialization
  not read(v)
select v, "Local variable " + v.getName() + " is only assigned to, never read."
