import csharp

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(StringLiteral).getValue() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().getUndecoratedName() = "Sink" and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

module Flow = DataFlow::Global<FlowConfig>;

import Flow::PathGraph

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select sink
