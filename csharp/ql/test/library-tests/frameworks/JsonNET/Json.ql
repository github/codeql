import csharp

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr().(StringLiteral).getValue() = "tainted" }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall c | c.getArgument(0) = sink.asExpr() and c.getTarget().getName() = "Sink")
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Taint::flow(source, sink)
select source, sink
