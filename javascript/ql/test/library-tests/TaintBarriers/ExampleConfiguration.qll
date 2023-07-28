import javascript

DataFlow::Node sourceVariable() { result.asExpr().(VarRef).getName() = "sourceVariable" }

StringOps::ConcatenationRoot sinkConcatenation() {
  result.getConstantStringParts().matches("<sink>%</sink>")
}

class ExampleConfiguration extends TaintTracking::Configuration {
  ExampleConfiguration() { this = "ExampleConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(CallExpr).getCalleeName() = "SOURCE"
    or
    source = sourceVariable()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SINK" and
      DataFlow::valueNode(callExpr.getArgument(0)) = sink
    )
    or
    sink = sinkConcatenation()
  }

  override predicate isSanitizerIn(DataFlow::Node node) { node = sourceVariable() }

  override predicate isSanitizerOut(DataFlow::Node node) { node = sinkConcatenation() }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SANITIZE" and
      DataFlow::valueNode(callExpr.getArgument(0)) = node
    )
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    // add additional generic sanitizers
    guard instanceof TaintTracking::AdHocWhitelistCheckSanitizer
  }
}
