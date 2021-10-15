/**
 * @name Unchecked function argument
 * @description Functions should check their arguments before their first use.
 * @kind problem
 * @id cpp/jpl-c/checking-parameter-values
 * @problem.severity warning
 * @tags correctness
 *       reliability
 *       external/jpl
 */

import JPL_C.Tasks

predicate flow(Parameter p, ControlFlowNode n) {
  exists(p.getAnAccess()) and n = p.getFunction().getBlock()
  or
  exists(ControlFlowNode mid |
    flow(p, mid) and not mid = p.getAnAccess() and n = mid.getASuccessor()
  )
}

VariableAccess firstAccess(Parameter p) { flow(p, result) and result = p.getAnAccess() }

from Parameter p, VariableAccess va
where
  va = firstAccess(p) and
  p.getFunction() instanceof PublicFunction and
  not exists(Expr e | e.isCondition() | e.getAChild*() = va)
select va, "This use of parameter " + p.getName() + " has not been checked."
