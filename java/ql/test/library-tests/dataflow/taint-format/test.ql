import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineFlowTest

class TaintFlowConf extends DefaultTaintFlowConf {
  override predicate isSink(DataFlow::Node n) { n instanceof DataFlow::ExprNode }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { result = any(TaintFlowConf config) }
}
