import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node n) { DefaultFlowConfig::isSink(n) }
}

import TaintFlowTest<Config>
