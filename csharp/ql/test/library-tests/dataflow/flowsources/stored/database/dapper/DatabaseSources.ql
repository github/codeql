import csharp
import semmle.code.csharp.security.dataflow.flowsources.FlowSources
import TestUtilities.InlineFlowTest
import TaintFlowTest<DatabaseConfig>

module DatabaseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc | mc.getTarget().hasName("Sink") | sink.asExpr() = mc.getArgument(0))
  }
}
