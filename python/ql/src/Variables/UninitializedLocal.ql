/**
 * @name Potentially uninitialized local variable
 * @description Using a local variable before it is initialized causes an UnboundLocalError.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision medium
 * @id py/uninitialized-local-variable
 */

import python
import Undefined
import semmle.python.pointsto.PointsTo

predicate uninitialized_local(NameNode use) {
  exists(FastLocalVariable local | use.uses(local) or use.deletes(local) | not local.escapes()) and
  (
    any(Uninitialized uninit).taints(use) and
    PointsToInternal::reachableBlock(use.getBasicBlock(), _)
    or
    not exists(EssaVariable var | var.getASourceUse() = use)
  )
}

predicate explicitly_guarded(NameNode u) {
  exists(Try t |
    t.getBody().contains(u.getNode()) and
    t.getAHandler().getType().pointsTo(ClassValue::nameError())
  )
}

from NameNode u
where uninitialized_local(u) and not explicitly_guarded(u)
select u.getNode(), "Local variable '" + u.getId() + "' may be used before it is initialized."
