/**
 * @name Dead field
 * @description Fields that are never read are likely unnecessary.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/dead-field
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.deadcode.DeadCode

from DeadField f, Element origin, string reason
where
  not f.isInDeadScope() and
  if exists(FieldRead read | read = f.getAnAccess())
  then (
    if
      exists(DeadRoot root |
        root = getADeadRoot(f.getAnAccess().(FieldRead).getEnclosingCallable())
      )
    then (
      origin = getADeadRoot(f.getAnAccess().(FieldRead).getEnclosingCallable()) and
      reason = " is only read from dead code originating at $@."
    ) else (
      origin = f and
      reason = " is only read from a dead-code cycle."
    )
  ) else (
    origin = f and
    reason = " is entirely unread."
  )
select f, "The field " + f.getName() + reason, origin, origin.getName()
