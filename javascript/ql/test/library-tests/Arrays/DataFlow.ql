import javascript

class ArrayFlowConfig extends DataFlow::Configuration {
  ArrayFlowConfig() { this = "ArrayFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr().getStringValue() = "source" }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}

from ArrayFlowConfig config, DataFlow::Node src, DataFlow::Node snk
where config.hasFlow(src, snk)
select src, snk
