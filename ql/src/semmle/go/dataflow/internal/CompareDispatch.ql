/**
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id go/compare-dispatch
 */

import go
import DataFlowDispatch

FuncDef viableCallableOld(CallExpr c) {
  exists(DataFlow::CallNode call | call.asExpr() = c | result = call.getACallee())
}

from CallExpr c, FuncDef fn, string msg
where
  fn = viableCallableOld(c) and not fn = viableCallable(c) and msg = "Missing"
  or
  not fn = viableCallableOld(c) and fn = viableCallable(c) and msg = "New"
select c, msg + " $@.", fn, "callee"
