import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import experimental.frameworks.CleverGo
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(CallExpr c | c.getTarget().getName() = "sink").getArgument(0)
  }
}

import TaintFlowTest<Config>
