import javascript

DataFlow::Node sourceVariable() { result.asExpr().(VarRef).getName() = "sourceVariable" }

StringOps::ConcatenationRoot sinkConcatenation() {
  result.getConstantStringParts().matches("<sink>%</sink>")
}

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(CallExpr).getCalleeName() = "SOURCE"
    or
    source = sourceVariable()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SINK" and
      DataFlow::valueNode(callExpr.getArgument(0)) = sink
    )
    or
    sink = sinkConcatenation()
  }

  predicate isBarrierIn(DataFlow::Node node) { node = sourceVariable() }

  predicate isBarrierOut(DataFlow::Node node) { node = sinkConcatenation() }

  additional predicate isBarrier1(DataFlow::Node node) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SANITIZE" and
      DataFlow::valueNode(callExpr.getArgument(0)) = node
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    isBarrier1(node)
    or
    node = TaintTracking::AdHocWhitelistCheckSanitizer::getABarrierNode()
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

deprecated class ExampleConfiguration extends TaintTracking::Configuration {
  ExampleConfiguration() { this = "ExampleConfiguration" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }

  override predicate isSanitizerIn(DataFlow::Node node) { TestConfig::isBarrierIn(node) }

  override predicate isSanitizerOut(DataFlow::Node node) { TestConfig::isBarrierOut(node) }

  override predicate isSanitizer(DataFlow::Node node) { TestConfig::isBarrier1(node) }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintTracking::AdHocWhitelistCheckSanitizer
  }
}
