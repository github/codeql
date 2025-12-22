import csharp

module ArrayFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasUndecoratedName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}
