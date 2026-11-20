import go
import semmle.go.dataflow.internal.DataFlowDispatch

from DataFlow::CallNode call, Callable target
where
  call.getTarget().getName() = "Greet" and
  target = viableCallable(call.asExpr()).asCallable()
select call.getEnclosingCallable().getName(), call,
  target.asFunction().(Method).getReceiverBaseType()
