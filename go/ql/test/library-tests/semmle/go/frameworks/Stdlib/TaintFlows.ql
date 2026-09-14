import go
import TestUtilities.InlineFlowTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Function f | f.getName() = "source").getACall().getResult() or
    source instanceof RemoteFlowSource
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Function f | f.getName() = "sink").getACall().getAnArgument()
  }
}

import FlowTest<TestConfig, TestConfig>
