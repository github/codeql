import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getTarget().getName() = ["getUntrustedData", "getUntrustedString"]
  }

  predicate isSink(DataFlow::Node sink) { sink = any(LoggerCall log).getAMessageComponent() }
}

import FlowTest<Config, Config>
