import cpp
import semmle.code.cpp.dataflow.TaintTracking

from FunctionCall call, DataFlow::Node source, DataFlow::Node sink
where
  call.getTarget().getName() = "snprintf" and
  call.getArgument(2).getValue().regexpMatch("(?s).*%s.*") and
  TaintTracking::localTaint(source, sink) and
  source.asExpr() = call and
  sink.asExpr() = call.getArgument(1)
select call