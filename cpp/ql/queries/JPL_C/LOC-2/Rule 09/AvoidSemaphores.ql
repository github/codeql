/**
 * @name Avoid semaphores
 * @description The use of semaphores or locks to access shared data should be avoided.
 * @kind problem
 * @id cpp/jpl-c/avoid-semaphores
 * @problem.severity recommendation
 * @tags concurrency
 *       external/jpl
 */

import Semaphores

from FunctionCall call, string kind
where
  call instanceof SemaphoreCreation and kind = "semaphores"
  or
  call instanceof LockingPrimitive and kind = "locking primitives"
select call, "Use of " + kind + " should be avoided."
