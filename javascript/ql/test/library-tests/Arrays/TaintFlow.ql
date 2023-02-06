import javascript

class ArrayTaintFlowConfig extends TaintTracking::Configuration {
  ArrayTaintFlowConfig() { this = "ArrayTaintFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr().getStringValue() = "source" }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}

from ArrayTaintFlowConfig config, DataFlow::Node src, DataFlow::Node snk
where config.hasFlow(src, snk)
select src, snk
