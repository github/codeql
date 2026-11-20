import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source.asIndirectExpr().(FunctionCall).getTarget().hasGlobalName("source_bytes")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().hasGlobalName("consume") and sink.asIndirectExpr() = call.getArgument(1)
      or
      call.getTarget().hasGlobalName("consume_number") and sink.asExpr() = call.getArgument(1)
    )
  }
}

module Flow = TaintTracking::Global<Config>;

string status(FunctionCall call) {
  if
    exists(DataFlow::Node source, DataFlow::Node sink |
      Flow::flow(source, sink) and
      (sink.asIndirectExpr() = call.getArgument(1) or sink.asExpr() = call.getArgument(1))
    )
  then result = "tracked"
  else result = "untracked"
}

from FunctionCall call
where call.getTarget().hasGlobalName(["consume", "consume_number"])
select call.getArgument(0).getValueText(), status(call)
