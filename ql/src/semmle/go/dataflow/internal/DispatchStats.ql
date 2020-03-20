/**
 * @kind table
 * @id go/dispatch-stats
 */

import go
import DataFlowDispatch

FuncDef viableCallableOld(CallExpr c) {
  exists(DataFlow::CallNode call | call.asExpr() = c | result = call.getACallee())
}

from CallExpr c, int old, int new
where
  old = count(viableCallableOld(c)) and
  new = count(viableCallable(c)) and
  old != new
select c, old + " -> " + new
