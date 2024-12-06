import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    sourceNode(source, "qltest")
    or
    exists(Function fn | fn.hasQualifiedName(_, ["source", "taint"]) |
      source = fn.getACall().getResult()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    sinkNode(sink, "qltest")
    or
    exists(Function fn | fn.hasQualifiedName(_, "sink") | sink = fn.getACall().getAnArgument())
  }
}

import FlowTest<Config, Config>
