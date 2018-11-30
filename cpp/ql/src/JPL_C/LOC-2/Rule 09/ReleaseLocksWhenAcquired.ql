/**
 * @name Unreleased lock
 * @description Unlock operations shall always appear within the body of the same function that performs the matching lock operation.
 * @kind problem
 * @id cpp/jpl-c/release-locks-when-acquired
 * @problem.severity warning
 * @tags correctness
 *       concurrency
 *       external/jpl
 */

import Semaphores

from LockOperation lock
where lock.getAReachedNode() = lock.getEnclosingFunction()
select lock, "This lock operation may escape the function without a matching unlock."
