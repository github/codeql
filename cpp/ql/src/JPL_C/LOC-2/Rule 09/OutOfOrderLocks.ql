/**
 * @name Out-of-order locks
 * @description Where nested locks are inevitable, they should always be taken in the same order.
 * @kind problem
 * @id cpp/jpl-c/out-of-order-locks
 * @problem.severity warning
 * @tags correctness
 *       concurrency
 *       external/jpl
 */

import Semaphores

predicate lockOrder(LockOperation outer, LockOperation inner) {
  outer.getAReachedNode() = inner and
  inner.getLocked() != outer.getLocked()
}

int orderCount(Declaration outerLock, Declaration innerLock) {
  result =
    strictcount(LockOperation outer, LockOperation inner |
      outer.getLocked() = outerLock and
      inner.getLocked() = innerLock and
      lockOrder(outer, inner)
    )
}

from LockOperation outer, LockOperation inner
where
  lockOrder(outer, inner) and
  orderCount(outer.getLocked(), inner.getLocked()) <=
    orderCount(inner.getLocked(), outer.getLocked())
select inner, "Out-of-order locks: A " + inner.say() + " usually precedes a $@.", outer, outer.say()
