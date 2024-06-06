import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Function fn | fn.hasQualifiedName(_, ["getUntrustedString", "getUntrustedBytes"]) |
      source = fn.getACall().getResult()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Function fn | fn.hasQualifiedName(_, ["sinkString", "sinkBytes"]) |
      sink = fn.getACall().getAnArgument()
    )
  }
}

import TaintFlowTest<Config>
