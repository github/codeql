import csharp

class Config extends DataFlow::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(StringLiteral).getValue() = "taint source"
    or
    source.asParameter().hasName("tainted")
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().getName() = "Check" and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}
