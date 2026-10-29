/**
 * @name Avoid nested semaphores
 * @description Nested use of semaphores or locks should be avoided.
 * @kind problem
 * @id cpp/jpl-c/avoid-nested-semaphores
 * @problem.severity warning
 * @tags correctness
 *       concurrency
 *       external/jpl
 */

import Semaphores

LockOperation maybeLocked(Function f) {
  result.getEnclosingFunction() = f
  or
  exists(Function g | f.calls(g) | result = maybeLocked(g))
}

predicate intraproc(LockOperation inner, string msg, LockOperation outer) {
  inner = outer.getAReachedNode() and
  outer.getLocked() != inner.getLocked() and
  msg = "This lock operation is nested in a $@."
}

predicate interproc(FunctionCall inner, string msg, LockOperation outer) {
  inner = outer.getAReachedNode() and
  exists(LockOperation lock |
    lock = maybeLocked(inner.getTarget()) and lock.getLocked() != outer.getLocked()
  |
    msg = "This call may perform a " + lock.say() + " while under the effect of a $@."
  )
}

from LockOperation outer, FunctionCall inner, string msg
where intraproc(inner, msg, outer) or interproc(inner, msg, outer)
select inner, msg, outer, outer.say()
