import javascript
import testUtilities.ConsistencyChecking

class GeneratorFlowConfig extends DataFlow::Configuration {
  GeneratorFlowConfig() { this = "GeneratorFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr().getStringValue() = "source" }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}
