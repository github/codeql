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

query predicate flow(DataFlow::Node sink) { Flow::flowTo(sink) }
