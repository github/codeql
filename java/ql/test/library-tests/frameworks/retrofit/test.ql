import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import utils.test.InlineFlowTest

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink(DataFlow::Node n) {
    DefaultFlowConfig::isSink(n) or sinkNode(n, "request-forgery")
  }
}

import FlowTest<FlowConfig, DefaultFlowConfig>
