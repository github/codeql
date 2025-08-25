import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    DefaultFlowConfig::isSource(node)
    or
    node instanceof ActiveThreatModelSource
  }

  predicate isSink = DefaultFlowConfig::isSink/1;
}

import FlowTest<DefaultFlowConfig, Config>
