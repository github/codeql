import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import experimental.frameworks.CleverGo
import utils.test.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(CallExpr c | c.getTarget().getName() = "sink").getAnArgument()
  }
}

import TaintFlowTest<Config>
