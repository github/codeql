/**
 * @name Potentially uninitialized local variable
 * @description Using a local variable before it is initialized causes an UnboundLocalError.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision medium
 * @id py/uninitialized-local-variable
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch
import Undefined

predicate uninitialized_local(NameNode use) {
  exists(FastLocalVariable local | use.uses(local) or use.deletes(local) |
    not local.escapes() and not local = any(Nonlocal nl).getAVariable()
  ) and
  (
    any(Uninitialized uninit).taints(use) and
    Reachability::likelyReachable(use.getBasicBlock())
    or
    not exists(EssaVariable var | var.getASourceUse() = use)
  )
}

predicate explicitly_guarded(NameNode u) {
  exists(Try t, ExceptionTypes::NameError nameError |
    t.getBody().contains(u.getNode()) and
    nameError.getAUse().asExpr() = t.getAHandler().getType()
  )
}

from NameNode u
where uninitialized_local(u) and not explicitly_guarded(u)
select u.getNode(), "Local variable '" + u.getId() + "' may be used before it is initialized."
