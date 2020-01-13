import javascript

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PromiseFlowTestingConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().getStringValue() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    any(DataFlow::InvokeNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }
}

query predicate flow(DataFlow::Node source, DataFlow::Node sink) {
  any(Configuration a).hasFlow(source, sink)
}
