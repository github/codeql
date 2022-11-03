/**
 * @name Sleep with lock held
 * @description Calling 'Thread.sleep' with a lock held may lead to very poor
 *              performance or even deadlock.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/sleep-with-lock-held
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-833
 */

import java

from MethodAccess ma, Method sleep
where
  ma.getMethod() = sleep and
  sleep.hasName("sleep") and
  sleep.getDeclaringType().hasQualifiedName("java.lang", "Thread") and
  (
    ma.getEnclosingStmt().getEnclosingStmt*() instanceof SynchronizedStmt or
    ma.getEnclosingCallable().isSynchronized()
  )
select ma, "sleep() with lock held."
