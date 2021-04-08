/**
 * @name Explicit returns mixed with implicit (fall through) returns
 * @description Mixing implicit and explicit returns indicates a likely error as implicit returns always return 'None'.
 * @kind problem
 * @tags reliability
 *       maintainability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/mixed-returns
 */

import python

predicate explicitly_returns_non_none(Function func) {
  exists(Return return |
    return.getScope() = func and
    exists(Expr val | val = return.getValue() | not val instanceof None)
  )
}

predicate has_implicit_return(Function func) {
  exists(ControlFlowNode fallthru |
    fallthru = func.getFallthroughNode() and not fallthru.unlikelyReachable()
  )
  or
  exists(Return return | return.getScope() = func and not exists(return.getValue()))
}

from Function func
where explicitly_returns_non_none(func) and has_implicit_return(func)
select func,
  "Mixing implicit and explicit returns may indicate an error as implicit returns always return None."
