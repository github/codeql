import csharp

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof Literal }

  predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable decl | sink.asExpr() = decl.getInitializer())
  }
}

module Flow = TaintTracking::Global<FlowConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
