/**
 * @name Wait outside loop
 * @description Calling 'wait' outside a loop may result in the program continuing before the
 *              expected condition is met.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/wait-outside-loop
 * @tags reliability
 *       correctness
 *       concurrency
 */

import java

class WaitMethod extends Method {
  WaitMethod() {
    this.getName() = "wait" and
    this.getDeclaringType().getQualifiedName() = "java.lang.Object"
  }
}

from MethodAccess ma
where
  ma.getMethod() instanceof WaitMethod and
  not exists(LoopStmt s | ma.getEnclosingStmt().getEnclosingStmt*() = s)
select ma, "To avoid spurious wake-ups, 'wait' should only be called inside a loop."
