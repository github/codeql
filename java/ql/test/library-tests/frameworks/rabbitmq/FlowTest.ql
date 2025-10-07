import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node node) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | node.asExpr() = ma.getAnArgument())
  }
}

import TaintFlowTest<Config>
