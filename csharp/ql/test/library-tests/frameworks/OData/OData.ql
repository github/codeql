import csharp

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    exists(Parameter p | p = n.asParameter() |
      p.getType().hasFullyQualifiedName("Microsoft.AspNet.OData", "ODataActionParameters")
      or
      p.getType().getUnboundDeclaration().hasFullyQualifiedName("Microsoft.AspNet.OData", "Delta`1")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall c | c.getArgument(0) = sink.asExpr() and c.getTarget().hasName("Sink"))
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Taint::flow(source, sink)
select source, sink
