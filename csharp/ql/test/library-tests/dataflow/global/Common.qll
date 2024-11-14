import csharp

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(StringLiteral).getValue() = "taint source" //and
    or
    // source.getLocation().getStartLine() = 81
    source.asParameter().hasName("tainted")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().getUndecoratedName() = "Check" and
      mc.getAnArgument() = sink.asExpr()
    )
  }
  // predicate includeHiddenNodes() { any() }
}

module Flow = DataFlow::Global<FlowConfig>;
