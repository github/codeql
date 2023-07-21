import csharp

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(StringLiteral).getValue() = "taint source"
    or
    source.asParameter().hasName("tainted")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().getUndecoratedName() = "Check" and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

module Flow = DataFlow::Global<FlowConfig>;
