import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | node.asExpr() = ma.getAnArgument())
  }
}

import TaintFlowTest<Config>
