import csharp

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr().(StringLiteral).getValue() = "tainted" }

  predicate isSink(DataFlow::Node node) {
    exists(MethodCall mc | mc.getTarget().hasName("Sink") and node.asExpr() = mc.getArgument(0))
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Taint::flow(source, sink)
select sink, "Data flow from $@.", source, source.toString()
