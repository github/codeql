import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineFlowTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source =
      any(Function f | f.getName() = ["getUntrustedString", "getUntrustedStruct"])
          .getACall()
          .getResult()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Function f | f.getName() = "sinkString").getACall().getAnArgument() or
    sink = any(LoggerCall log).getAMessageComponent()
  }
}

import FlowTest<TestConfig, TestConfig>
