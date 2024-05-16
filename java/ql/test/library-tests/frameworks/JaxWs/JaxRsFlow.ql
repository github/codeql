import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    DefaultFlowConfig::isSource(node)
    or
    node instanceof ThreatModelFlowSource
  }

  predicate isSink = DefaultFlowConfig::isSink/1;
}

import FlowTest<Config, Config>
